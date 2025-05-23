Please implement the asyn_fifo module and the dual_port_RAM module here:

module asyn_fifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					wclk	, 
	input 					rclk	,   
	input 					wrstn	,
	input					rrstn	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output wire				wfull	,
	output wire				rempty	,
	output wire [WIDTH-1:0]	rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

reg 	[ADDR_WIDTH-1:0]	waddr_bin;
reg 	[ADDR_WIDTH-1:0]	raddr_bin;
reg 	[ADDR_WIDTH-1:0]	waddr_gray;
reg 	[ADDR_WIDTH-1:0]	raddr_gray;
reg 	[ADDR_WIDTH-1:0]	wptr_buff	[1:0];
reg 	[ADDR_WIDTH-1:0]	rptr_buff	[1:0];
reg 	[ADDR_WIDTH-1:0]	wptr;
reg 	[ADDR_WIDTH-1:0]	rptr_syn;

wire	[ADDR_WIDTH-1:0]	wptr_gray	=	wptr ^ (wptr >> 1);
wire	[ADDR_WIDTH-1:0]	rptr_gray	=	rptr_syn ^ (rptr_syn >> 1);

reg	[WIDTH-1:0]	mem	[DEPTH-1:0];

always @(posedge wclk or negedge wrstn)
begin
	if (!wrstn)
		waddr_bin <= 0;
	else
		waddr_bin <= waddr_bin + winc;
end

always @(posedge rclk or negedge rrstn)
begin
	if (!rrstn)
		raddr_bin <= 0;
	else
		raddr_bin <= raddr_bin + rinc;
end

assign	wfull = (wptr[ADDR_WIDTH-1:0] == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});
assign	rempty = (wptr == rptr_syn);

dual_port_RAM u_ram (
	.wclk	(wclk),
	.rclk	(rclk),
	.wenc	(winc),
	.waddr	(waddr_bin[ADDR_WIDTH-2:0]),
	.wdata	(wdata),
	.renc	(rinc),
	.raddr	(raddr_bin[ADDR_WIDTH-2:0]),
	.rdata	(rdata)
);

always @(posedge wclk or negedge wrstn)
begin
	if (!wrstn)
		wptr <= 0;
	else
		wptr <= wptr_gray;
end

always @(posedge rclk or negedge rrstn)
begin
	if (!rrstn)
		rptr_syn <= 0;
	else
		rptr_syn <= rptr_gray;
end

genvar i;
generate
	for (i = 0; i < 2; i = i + 1)
		always @(posedge wclk or negedge wrstn)
		begin
			if (!wrstn)
				wptr_buff[i] <= 0;
			else
				wptr_buff[i] <= wptr;
		end
endgenerate

generate
	for (i = 0; i < 2; i = i + 1)
		always @(posedge rclk or negedge rrstn)
		begin
			if (!rrstn)
				rptr_buff[i] <= 0;
			else
				rptr_buff[i] <= rptr_syn;
		end
endgenerate

endmodule

module dual_port_RAM#(
	parameter	DEPTH = 16,
	parameter	WIDTH = 8
)(
	input 				wclk	,
	input 				rclk	,
	input 				wenc	,
	input 	[WIDTH-1:0]	waddr	,
	input 	[WIDTH-1:0]	wdata	,
	input 				renc	,
	input 	[WIDTH-1:0]	raddr	,
	output reg	[WIDTH-1:0]	rdata
);

reg