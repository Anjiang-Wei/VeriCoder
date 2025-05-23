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

reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
reg [ADDR_WIDTH-1:0] wptr, rptr, rptr_syn;
reg [ADDR_WIDTH-1:0] wptr_buff, rptr_buff;

// Write pointer logic
always @(posedge wclk or negedge wrstn) begin
	if (~wrstn)
		waddr_bin <= 0;
	else if (winc)
		waddr_bin <= waddr_bin + 1;
end

// Read pointer logic
always @(posedge rclk or negedge rrstn) begin
	if (~rrstn)
		raddr_bin <= 0;
	else if (rinc)
		raddr_bin <= raddr_bin + 1;
end

// Convert binary to Gray code for write pointer
always @(posedge wclk or negedge wrstn) begin
	if (~wrstn)
		wptr <= 0;
	else
		wptr <= {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1] ^ waddr_bin[ADDR_WIDTH-2], waddr_bin[ADDR_WIDTH-2] ^ waddr_bin[ADDR_WIDTH-3], waddr_bin[ADDR_WIDTH-3] ^ waddr_bin[ADDR_WIDTH-4]};
end

// Convert binary to Gray code for read pointer
always @(posedge rclk or negedge rrstn) begin
	if (~rrstn)
		rptr <= 0;
	else
		rptr <= {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1] ^ raddr_bin[ADDR_WIDTH-2], raddr_bin[ADDR_WIDTH-2] ^ raddr_bin[ADDR_WIDTH-3], rptr[ADDR_WIDTH-4]};
end

// Synchronize read pointer with write clock
always @(posedge wclk or negedge wrstn) begin
	if (~wrstn)
		rptr_buff <= 0;
	else
		rptr_buff <= rptr;
end

// Synchronize write pointer with read clock
always @(posedge rclk or negedge rrstn) begin
	if (~rrstn)
		wptr_buff <= 0;
	else
		wptr_buff <= wptr;
end

// Output full and empty signals
assign wfull = (wptr_buff[ADDR_WIDTH-1] != rptr_buff[ADDR_WIDTH-1]) && (wptr_buff[ADDR_WIDTH-2:ADDR_WIDTH-3] == rptr_buff[ADDR_WIDTH-2:ADDR_WIDTH-3]);
assign rempty = (wptr == rptr);

// Instantiate dual-port RAM
dual_port_RAM dpram(
	.wclk(wclk),
	.wenc(winc),
	.waddr(waddr_bin),
	.wdata(wdata),
	.rclk(rclk),
	.renc(rinc),
	.raddr(rptr_buff),
	.rdata(rdata)
);

endmodule

module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input 					wclk,
	input 					wenc,
	input [$clog2(DEPTH)-1:0] waddr,
	input [WIDTH-1:0] wdata,
	input 					rclk,
	input 					renc,
	input [$clog2(DEPTH)-1:0] raddr,
	output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

// Write logic
always @(posedge wclk) begin
	if (wenc)
		RAM_MEM[waddr] <= wdata;
end

// Read logic
always @(posedge rclk) begin
	if (renc)
		rdata <= RAM_MEM[raddr];
end

endmodule