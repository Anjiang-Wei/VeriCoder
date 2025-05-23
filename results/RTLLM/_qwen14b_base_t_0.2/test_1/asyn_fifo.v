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
parameter PTR_WIDTH = $clog2(DEPTH);

// Dual-port RAM submodule
module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input 					wclk	, 
	input 					rclk	,   
	input 					wenc	,
	input [$clog2(DEPTH)-1:0]	waddr	,
	input 		[WIDTH-1:0]	wdata	,
	input 					renc	,
	input [$clog2(DEPTH)-1:0]	raddr	,
	output reg [WIDTH-1:0]	rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if (wenc)
		RAM_MEM[waddr] <= wdata;
end

always @(posedge rclk) begin
	if (renc)
		rdata <= RAM_MEM[raddr];
end

endmodule

// Write Pointer Synchronizer
reg [PTR_WIDTH-1:0] wptr;
reg [PTR_WIDTH-1:0] wptr_gray;
reg [PTR_WIDTH-1:0] wptr_gray_buff;
reg [PTR_WIDTH-1:0] wptr_bin;

// Read Pointer Synchronizer
reg [PTR_WIDTH-1:0] rptr;
reg [PTR_WIDTH-1:0] rptr_gray;
reg [PTR_WIDTH-1:0] rptr_gray_buff;
reg [PTR_WIDTH-1:0] rptr_bin;
reg [PTR_WIDTH-1:0] rptr_syn;

// Gray code conversion
function [PTR_WIDTH-1:0] gray_to_bin;
	input [PTR_WIDTH-1:0] gray;
	reg [PTR_WIDTH-1:0] bin;
	integer i;
begin
	bin = gray;
	for (i = PTR_WIDTH-1; i > 0; i = i - 1)
		bin[i-1] = bin[i] ^ bin[i-1];
	gray_to_bin = bin;
end
endfunction

// Write Pointer Logic
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		wptr_bin <= 0;
	end else if (winc) begin
		wptr_bin <= wptr_bin + 1;
	end
end

assign wptr_gray = {wptr_bin[PTR_WIDTH-1], wptr_bin[PTR_WIDTH-1:1] ^ wptr_bin[PTR_WIDTH-2:0]};
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		wptr_gray_buff <= 0;
	end else begin
		wptr_gray_buff <= wptr_gray;
	end
end

// Read Pointer Logic
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr_bin <= 0;
	end else if (rinc) begin
		rptr_bin <= rptr_bin + 1;
	end
end

assign rptr_gray = {rptr_bin[PTR_WIDTH-1], rptr_bin[PTR_WIDTH-1:1] ^ rptr_bin[PTR_WIDTH-2:0]};
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr_gray_buff <= 0;
	end else begin
		rptr_gray_buff <= rptr_gray;
	end
end

// Read Pointer Synchronization
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr_gray_buff;
	end
end

// Full and Empty Signals
assign wfull = (wptr_gray[PTR_WIDTH-1] != rptr_syn[PTR_WIDTH-1]) && (wptr_gray[PTR_WIDTH-2:0] == rptr_syn[PTR_WIDTH-2:0]);
assign rempty = (wptr_gray == rptr_syn);

// Dual-port RAM instantiation
wire wenc = winc & ~wfull;
wire renc = rinc & ~rempty;
wire [ADDR_WIDTH-1:0] waddr = wptr_gray[PTR_WIDTH-2:0];
wire [ADDR_WIDTH-1:0] raddr = rptr_syn[PTR_WIDTH-2:0];

dual_port_RAM#(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_inst (
	.wclk(wclk),
	.rclk(rclk),
	.wenc(wenc),
	.waddr(waddr),
	.wdata(wdata),
	.renc(renc),
	.raddr(raddr),
	.rdata(rdata)
);

endmodule