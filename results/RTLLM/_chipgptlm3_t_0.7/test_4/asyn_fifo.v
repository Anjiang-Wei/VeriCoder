verilog
// dual_port_RAM module
module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input wclk,
	input wenc,
	input [ADDR_WIDTH-1:0] waddr,
	input [WIDTH-1:0] wdata,
	input rclk,
	input renc,
	input [ADDR_WIDTH-1:0] raddr,
	output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if (wenc) RAM_MEM[waddr] <= wdata;
end

always @(posedge rclk) begin
	if (renc) rdata <= RAM_MEM[raddr];
end

endmodule

// asyn_fifo module
module asyn_fifo#(
	parameter WIDTH = 8,
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

// Dual-port RAM
wire wclk;
wire rclk;
wire wenc;
wire renc;
wire [ADDR_WIDTH-1:0] waddr;
wire [WIDTH-1:0] wdata;
wire [ADDR_WIDTH-1:0] raddr;
reg [WIDTH-1:0] rdata;
dual_port_RAM RAM(.wclk(wclk),.wenc(wenc),.waddr(waddr),.wdata(wdata),.rclk(rclk),.renc(renc),.raddr(raddr),.rdata(rdata));

// Write pointer
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] wptr_syn;
reg [ADDR_WIDTH-1:0] wptr_buff;
wire [ADDR_WIDTH-1:0] wptr_next;

always @(posedge wclk) begin
	if (~wrstn) wptr <= 0;
	else wptr <= wptr_next;
end

always @(posedge wclk) begin
	wptr_syn <= wptr;
end

always @(posedge wclk) begin
	wptr_buff <= wptr;
end

assign waddr = wptr_syn;
assign wenc = winc;

always @(posedge wclk) begin
	if (~wrstn) wptr_buff <= 0;
	else if (winc) wptr_buff <= wptr;
end

assign wptr_next = wptr + 1;

// Read pointer
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] rptr_syn;
reg [ADDR_WIDTH-1:0] rptr_buff;
wire [ADDR_WIDTH-1:0] rptr_next;
wire [ADDR_WIDTH-1:0] rptr_gray;

always @(posedge rclk) begin
	if (~rrstn) rptr <= 0;
	else rptr <= rptr_next;
end

always @(posedge rclk) begin
	rptr_syn <= rptr;
end

always @(posedge rclk) begin
	rptr_buff <= rptr;
end

assign raddr = rptr_syn;
assign renc = rinc;

always @(posedge rclk) begin
	if (~rrstn) rptr_buff <= 0;
	else if (rinc) rptr_buff <= rptr;
end

assign rptr_next = rptr + 1;

assign rptr_gray = {rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2], rptr_syn[ADDR_WIDTH-3], rptr_syn[ADDR_WIDTH-4]} ^ ({rptr_syn[ADDR_WIDTH-2], rptr_syn[ADDR_WIDTH-3], rptr_syn[ADDR_WIDTH-4], rptr_syn[ADDR_WIDTH-5]} ^ ({rptr_syn[ADDR_WIDTH-3], rptr_syn[ADDR_WIDTH-4], rptr_syn[ADDR_WIDTH-5], rptr_syn[ADDR_WIDTH-6]} ^ ({rptr_syn[ADDR_WIDTH-4], rptr_syn[ADDR_WIDTH-5], rptr_syn[ADDR_WIDTH-6], rptr_syn[ADDR_WIDTH-7]} ^ ({rptr_syn[ADDR_WIDTH-5], rptr_syn[ADDR_WIDTH-6], rptr_syn[ADDR_WIDTH-7], rptr_syn[ADDR_WIDTH-8]} ^ ({rptr_syn[ADDR_WIDTH-6], rptr_syn[ADDR_WIDTH-7], rptr_syn[ADDR_WIDTH-8], rptr_syn[ADDR_WIDTH-9]} ^ ({r