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

reg [ADDR_WIDTH-1:0] waddr_bin, wptr, wptr_buff;
reg [ADDR_WIDTH-1:0] raddr_bin, rptr, rptr_syn, rptr_buff;

reg [ADDR_WIDTH-1:0] waddr, raddr;
wire [ADDR_WIDTH-1:0] waddr_gray, raddr_gray;

wire wen, ren;

assign waddr = waddr_bin;
assign raddr = raddr_bin;

// Gray code conversion
assign wptr = {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1] ^ waddr_bin[ADDR_WIDTH-2], waddr_bin[ADDR_WIDTH-2] ^ waddr_bin[ADDR_WIDTH-3], waddr_bin[ADDR_WIDTH-3] ^ waddr_bin[ADDR_WIDTH-4]};
assign rptr = {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1] ^ raddr_bin[ADDR_WIDTH-2], raddr_bin[ADDR_WIDTH-2] ^ raddr_bin[ADDR_WIDTH-3], raddr_bin[ADDR_WIDTH-3] ^ raddr_bin[ADDR_WIDTH-4]};

// Pointer buffers
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		wptr_buff <= 0;
	end else begin
		wptr_buff <= wptr;
	end
end

always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr_buff <= 0;
	end else begin
		rptr_buff <= rptr;
	end
end

// Synchronize read pointer
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr_buff;
	end
end

// Write pointer
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		waddr_bin <= 0;
	end else if (winc) begin
		waddr_bin <= (waddr_bin == ADDR_WIDTH'-1) ? 0 : waddr_bin + 1;
	end
end

// Read pointer
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		raddr_bin <= 0;
	end else if (rinc) begin
		raddr_bin <= (raddr_bin == ADDR_WIDTH'-1) ? 0 : raddr_bin + 1;
	end
end

// Write and read enable
assign wen = winc && !wfull;
assign ren = rinc && !rempty;

// Full and empty signals
assign wfull = (wptr == ~rptr_syn[ADDR_WIDTH-1] & rptr_syn[ADDR_WIDTH-1:ADDR_WIDTH-4] == wptr[ADDR_WIDTH-1:ADDR_WIDTH-4]);
assign rempty = (rptr_syn == wptr);

// Dual-port RAM
dual_port_RAM ram_inst (
	.wclk(wclk),
	.wenc(wen),
	.waddr(waddr),
	.wdata(wdata),
	.rclk(rclk),
	.renc(ren),
	.raddr(raddr),
	.rdata(rdata)
);

endmodule

// Dual-port RAM module
module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input 					wclk	,
	input 					wenc	,
	input [$clog2(DEPTH)-1:0]	waddr	,
	input [WIDTH-1:0]		wdata	,
	input 					rclk	,
	input 					renc	,
	input [$clog2(DEPTH)-1:0]	raddr	,
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