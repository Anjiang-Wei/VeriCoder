module asyn_fifo#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
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
reg [ADDR_WIDTH-1:0] wptr, rptr;
reg [ADDR_WIDTH-1:0] wptr_buff, rptr_buff;
reg [ADDR_WIDTH-1:0] wptr_syn, rptr_syn;

wire wen, ren;
wire [ADDR_WIDTH-1:0] waddr, raddr;

assign wen = winc & ~wfull;
assign ren = rinc & ~rempty;
assign waddr = waddr_bin[ADDR_WIDTH-1:0];
assign raddr = rptr_syn;

// Dual-port RAM
dual_port_RAM dual_port_RAM_inst (
	.wclk(wclk),
	.wenc(wen),
	.waddr(waddr),
	.wdata(wdata),
	.rclk(rclk),
	.renc(ren),
	.raddr(raddr),
	.rdata(rdata)
);

// Write pointer logic
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn)
		waddr_bin <= 0;
	else if (winc)
		waddr_bin <= waddr_bin + 1;
end

// Read pointer logic
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn)
		raddr_bin <= 0;
	else if (rinc)
		raddr_bin <= raddr_bin + 1;
end

// Convert write pointer to Gray code
always @(*) begin
	wptr = {1'b0, waddr_bin} ^ (waddr_bin >> 1);
end

// Convert read pointer to Gray code
always @(*) begin
	rptr = {1'b0, raddr_bin} ^ (raddr_bin >> 1);
end

// Synchronize write pointer
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn)
		wptr_buff <= 0;
	else
		wptr_buff <= wptr;
end

// Synchronize read pointer
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn)
		rptr_buff <= 0;
	else
		rptr_buff <= rptr;
end

// Synchronize write pointer for full condition
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn)
		wptr_syn <= 0;
	else
		wptr_syn <= wptr_buff;
end

// Synchronize read pointer for empty condition
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn)
		rptr_syn <= 0;
	else
		rptr_syn <= rptr_buff;
end

// Full and empty signals
assign wfull = (wptr_syn[ADDR_WIDTH-1] != rptr_syn[ADDR_WIDTH-1]) && (wptr_syn[ADDR_WIDTH-2:0] == rptr_syn[ADDR_WIDTH-2:0]);
assign rempty = (wptr_syn == rptr_syn);

endmodule

// Dual-port RAM module
module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input 					wclk	,
	input 					wenc	,
	input [ADDR_WIDTH-1:0]	waddr	,
	input 		[WIDTH-1:0]	wdata	,
	input 					rclk	,
	input 					renc	,
	input [ADDR_WIDTH-1:0]	raddr	,
	output reg [WIDTH-1:0]	rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

integer i;

initial begin
	for (i = 0; i < DEPTH; i = i + 1) begin
		RAM_MEM[i] = 0;
	end
end

always @(posedge wclk) begin
	if (wenc)
		RAM_MEM[waddr] <= wdata;
end

always @(posedge rclk) begin
	if (renc)
		rdata <= RAM_MEM[raddr];
end

endmodule