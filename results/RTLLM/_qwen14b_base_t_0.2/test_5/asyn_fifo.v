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
localparam GRAY_WIDTH = ADDR_WIDTH + 1; // Gray code width is one bit larger than binary address width

// Internal signals
wire [ADDR_WIDTH-1:0] waddr_bin;
wire [ADDR_WIDTH-1:0] raddr_bin;
wire [GRAY_WIDTH-1:0] wptr;
wire [GRAY_WIDTH-1:0] rptr;
wire [GRAY_WIDTH-1:0] rptr_syn;
wire [ADDR_WIDTH-1:0] waddr;
wire [ADDR_WIDTH-1:0] raddr;
wire wenc;
wire renc;

// Write pointer logic
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		waddr_bin <= 0;
	end else if (winc) begin
		waddr_bin <= waddr_bin + 1;
	end
end

// Read pointer logic
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		raddr_bin <= 0;
	end else if (rinc) begin
		raddr_bin <= raddr_bin + 1;
	end
end

// Convert binary to Gray code
function [GRAY_WIDTH-1:0] bin_to_gray;
	input [ADDR_WIDTH-1:0] bin;
	begin
		bin_to_gray = bin ^ (bin >> 1);
	end
endfunction

// Write pointer to Gray code
assign wptr = bin_to_gray(waddr_bin);

// Read pointer to Gray code
assign rptr = bin_to_gray(raddr_bin);

// Read pointer synchronizer
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr;
	end
end

// Address calculation
assign waddr = wptr[ADDR_WIDTH-1:0];
assign raddr = rptr_syn[ADDR_WIDTH-1:0];

// Write enable signal
assign wenc = winc & !wfull;

// Read enable signal
assign renc = rinc & !rempty;

// Instantiate dual-port RAM
dual_port_RAM #(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
) dual_port_RAM_inst (
	.wclk(wclk),
	.wenc(wenc),
	.waddr(waddr),
	.wdata(wdata),
	.rclk(rclk),
	.renc(renc),
	.raddr(raddr),
	.rdata(rdata)
);

// Full signal generation
assign wfull = (wptr[GRAY_WIDTH-1] != rptr_syn[GRAY_WIDTH-1]) && (wptr[GRAY_WIDTH-2:0] == rptr_syn[GRAY_WIDTH-2:0]);

// Empty signal generation
assign rempty = (wptr == rptr_syn);

endmodule

// Dual-port RAM module
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
	if (wenc) begin
		RAM_MEM[waddr] <= wdata;
	end
end

always @(posedge rclk) begin
	if (renc) begin
		rdata <= RAM_MEM[raddr];
	end
end

endmodule