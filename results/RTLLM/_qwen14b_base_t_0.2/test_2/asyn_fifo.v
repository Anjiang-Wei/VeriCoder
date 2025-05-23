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
localparam GRAY_WIDTH = ADDR_WIDTH + 1; // Gray code width

// Internal signals
wire [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
wire [GRAY_WIDTH-1:0] wptr, rptr;
wire [ADDR_WIDTH-1:0] wptr_syn, rptr_syn;
wire wenc, renc;

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

// Convert binary address to Gray code
function [GRAY_WIDTH-1:0] bin_to_gray;
	input [ADDR_WIDTH-1:0] bin;
	begin
		bin_to_gray = bin ^ (bin >> 1);
	end
endfunction

// Write pointer in Gray code
assign wptr = bin_to_gray(waddr_bin);

// Read pointer in Gray code
assign rptr = bin_to_gray(raddr_bin);

// Write pointer synchronizer
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		wptr_syn <= 0;
	end else begin
		wptr_syn <= wptr;
	end
end

// Read pointer synchronizer
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr;
	end
end

// Full and empty signals
assign wfull = (wptr[GRAY_WIDTH-1] != rptr_syn[GRAY_WIDTH-1]) && (wptr_syn == rptr_syn);
assign rempty = (wptr_syn == rptr_syn);

// Write enable and read enable signals
assign wenc = winc && !wfull;
assign renc = rinc && !rempty;

// Dual-port RAM instantiation
dual_port_RAM #(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
) ram (
	.wclk(wclk),
	.wenc(wenc),
	.waddr(waddr_bin),
	.wdata(wdata),
	.rclk(rclk),
	.renc(renc),
	.raddr(rptr_syn[ADDR_WIDTH-1:0]),
	.rdata(rdata)
);

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

// Write operation
always @(posedge wclk) begin
	if (wenc) begin
		RAM_MEM[waddr] <= wdata;
	end
end

// Read operation
always @(posedge rclk) begin
	if (renc) begin
		rdata <= RAM_MEM[raddr];
	end
end

endmodule