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
parameter GRAY_WIDTH = $clog2(DEPTH) + 1;

// Internal signals
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [GRAY_WIDTH-1:0] wptr;
reg [GRAY_WIDTH-1:0] rptr;
reg [GRAY_WIDTH-1:0] rptr_syn;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;
wire [ADDR_WIDTH-1:0] waddr;
wire [ADDR_WIDTH-1:0] raddr;
wire wenc;
wire renc;

// Gray code conversion
assign wptr = {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1] ^ waddr_bin[ADDR_WIDTH-2] ^ waddr_bin[ADDR_WIDTH-3] ^ waddr_bin[ADDR_WIDTH-4], waddr_bin[ADDR_WIDTH-2] ^ waddr_bin[ADDR_WIDTH-3], waddr_bin[ADDR_WIDTH-3] ^ waddr_bin[ADDR_WIDTH-4], waddr_bin[ADDR_WIDTH-4]};
assign rptr = {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1] ^ raddr_bin[ADDR_WIDTH-2] ^ raddr_bin[ADDR_WIDTH-3] ^ raddr_bin[ADDR_WIDTH-4], raddr_bin[ADDR_WIDTH-2] ^ raddr_bin[ADDR_WIDTH-3], raddr_bin[ADDR_WIDTH-3] ^ raddr_bin[ADDR_WIDTH-4], raddr_bin[ADDR_WIDTH-4]};

// Write pointer buffer
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		wptr_buff <= 0;
	end else if (winc) begin
		wptr_buff <= wptr[ADDR_WIDTH-1:0];
	end
end

// Read pointer buffer
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr_buff <= 0;
	end else if (rinc) begin
		rptr_buff <= rptr[ADDR_WIDTH-1:0];
	end
end

// Read pointer synchronizer
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr_buff;
	end
end

// Write address
assign waddr = wptr[ADDR_WIDTH-1:0];
assign wenc = winc;

// Read address
assign raddr = rptr_syn[ADDR_WIDTH-1:0];
assign renc = rinc;

// Full and empty signals
assign wfull = (wptr[GRAY_WIDTH-1] != rptr[GRAY_WIDTH-1]) && (wptr[GRAY_WIDTH-2:0] == rptr[GRAY_WIDTH-2:0]);
assign rempty = (wptr[ADDR_WIDTH-1:0] == rptr_syn[ADDR_WIDTH-1:0]);

// Dual-port RAM
dual_port_RAM ram(
	.wclk(wclk),
	.wenc(wenc),
	.waddr(waddr),
	.wdata(wdata),
	.rclk(rclk),
	.renc(renc),
	.raddr(raddr),
	.rdata(rdata)
);

// Write pointer increment
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		waddr_bin <= 0;
	end else if (winc && !wfull) begin
		waddr_bin <= waddr_bin + 1;
	end
end

// Read pointer increment
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		raddr_bin <= 0;
	end else if (rinc && !rempty) begin
		raddr_bin <= raddr_bin + 1;
	end
end

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