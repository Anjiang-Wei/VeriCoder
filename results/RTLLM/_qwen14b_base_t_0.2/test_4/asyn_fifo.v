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
parameter GRAY_WIDTH = $clog2(DEPTH);

// Internal signals
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [GRAY_WIDTH-1:0] wptr;
reg [GRAY_WIDTH-1:0] rptr;
reg [GRAY_WIDTH-1:0] rptr_syn;
reg [WIDTH-1:0] rdata_int;

// Dual-port RAM instantiation
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
	.wclk(wclk),
	.wenc(wenc),
	.waddr(waddr_bin),
	.wdata(wdata),
	.rclk(rclk),
	.renc(renc),
	.raddr(raddr_bin),
	.rdata(rdata_int)
);

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

// Write pointer to Gray code conversion
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		wptr <= 0;
	end else begin
		wptr[0] <= waddr_bin[0];
		for (int i = 1; i < GRAY_WIDTH; i = i + 1) begin
			wptr[i] <= waddr_bin[i] ^ wptr[i-1];
		end
	end
end

// Read pointer to Gray code conversion
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr <= 0;
	end else begin
		rptr[0] <= raddr_bin[0];
		for (int i = 1; i < GRAY_WIDTH; i = i + 1) begin
			rptr[i] <= raddr_bin[i] ^ rptr[i-1];
		end
	end
end

// Read pointer synchronizer
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr;
	end
end

// Write enable control
wire wenc;
assign wenc = winc && !wfull;

// Read enable control
wire renc;
assign renc = rinc && !rempty;

// Full and empty signals
assign wfull = (wptr[GRAY_WIDTH-1] != rptr_syn[GRAY_WIDTH-1]) && (wptr[GRAY_WIDTH-2:0] == rptr_syn[GRAY_WIDTH-2:0]);
assign rempty = (wptr == rptr_syn);

// Data read output
assign rdata = rdata_int;

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