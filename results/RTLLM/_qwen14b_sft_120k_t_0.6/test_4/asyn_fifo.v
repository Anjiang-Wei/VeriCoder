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

reg [ADDR_WIDTH-1:0] waddr_bin, waddr_bin_prev;
reg [ADDR_WIDTH-1:0] raddr_bin, raddr_bin_prev;

reg [ADDR_WIDTH-1:0] wptr, rptr;
reg [ADDR_WIDTH-1:0] wptr_syn, rptr_syn;

reg wen, ren;

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

// Gray code conversion
assign wptr = {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1] ^ waddr_bin[ADDR_WIDTH-2], waddr_bin[ADDR_WIDTH-2] ^ waddr_bin[ADDR_WIDTH-3], waddr_bin[ADDR_WIDTH-3] ^ waddr_bin[ADDR_WIDTH-4]};
assign rptr = {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1] ^ raddr_bin[ADDR_WIDTH-2], raddr_bin[ADDR_WIDTH-2] ^ raddr_bin[ADDR_WIDTH-3], raddr_bin[ADDR_WIDTH-3] ^ raddr_bin[ADDR_WIDTH-4]};

// Synchronize pointers
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		wptr_syn <= 0;
	end else begin
		wptr_syn <= wptr;
	end
end

always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr;
	end
end

// Control signal logic
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		wen <= 1'b0;
		wptr_syn <= 0;
		waddr_bin_prev <= 0;
	end else begin
		wen <= winc;
		wptr_syn <= wptr;
		waddr_bin_prev <= waddr_bin;
	end
end

always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		ren <= 1'b0;
		rptr_syn <= 0;
		raddr_bin_prev <= 0;
	end else begin
		ren <= rinc;
		rptr_syn <= rptr;
		raddr_bin_prev <= raddr_bin;
	end
end

// Full and empty signals
assign wfull = (wptr_syn == {1'b1, rptr_syn[ADDR_WIDTH-2:0]});
assign rempty = (rptr_syn == wptr_syn);

// Instantiate dual-port RAM
dual_port_RAM #(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
) dual_port_RAM_inst (
	.wclk(wclk),
	.wenc(wen),
	.waddr(waddr_bin_prev),
	.wdata(wdata),
	.rclk(rclk),
	.renc(ren),
	.raddr(raddr_bin_prev),
	.rdata(rdata)
);

endmodule

module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input wclk,
	input wenc,
	input [$clog2(DEPTH)-1:0] waddr,
	input [WIDTH-1:0] wdata,
	input rclk,
	input renc,
	input [$clog2(DEPTH)-1:0] raddr,
	output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

// Write logic
always @(posedge wclk) begin
	if (wenc) begin
		RAM_MEM[waddr] <= wdata;
	end
end

// Read logic
always @(posedge rclk) begin
	if (renc) begin
		rdata <= RAM_MEM[raddr];
	end
end

endmodule