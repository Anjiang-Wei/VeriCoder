module asyn_fifo#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input wclk,
	input rclk,
	input wrstn,
	input rrstn,
	input winc,
	input rinc,
	input [WIDTH-1:0] wdata,

	output wire wfull,
	output wire rempty,
	output wire [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

// Dual-port RAM module
module dual_port_RAM#(
	parameter DEPTH = 16,
	parameter WIDTH = 8
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
integer i;

always @(posedge wclk) begin
	if (wenc)
		RAM_MEM[waddr] <= wdata;
end

always @(posedge rclk) begin
	if (renc)
		rdata <= RAM_MEM[raddr];
end

endmodule

// Instantiate the dual-port RAM
dual_port_RAM #(
	.DEPTH(DEPTH),
	.WIDTH(WIDTH)
) dual_port_RAM_inst (
	.wclk(wclk),
	.wenc(wen),
	.waddr(waddr_bin),
	.wdata(wdata),
	.rclk(rclk),
	.renc(rdata_valid),
	.raddr(raddr_bin),
	.rdata(rdata)
);

// Write pointer buffer
reg [ADDR_WIDTH-1:0] wptr_buff, wptr;
reg [ADDR_WIDTH-1:0] wptr_bin, wptr_gray;
reg [ADDR_WIDTH-1:0] wptr_syn;

always @(posedge wclk or negedge wrstn) begin
	if (!wrstn)
		wptr_buff <= 0;
	else
		wptr_buff <= wptr;
end

always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		wptr <= 0;
		wptr_bin <= 0;
		wptr_gray <= 0;
	end
	else if (winc) begin
		wptr <= wptr + 1;
		wptr_bin <= wptr;
		wptr_gray <= {1'b0, wptr_bin} ^ {wptr_bin, 1'b0};
	end
end

// Read pointer buffer
reg [ADDR_WIDTH-1:0] rptr_buff, rptr;
reg [ADDR_WIDTH-1:0] rptr_bin, rptr_gray;
reg [ADDR_WIDTH-1:0] rptr_syn;

always @(posedge rclk or negedge rrstn) begin
	if (!rrstn)
		rptr_buff <= 0;
	else
		rptr_buff <= rptr;
end

always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr <= 0;
		rptr_bin <= 0;
		rptr_gray <= 0;
	end
	else if (rinc) begin
		rptr <= rptr + 1;
		rptr_bin <= rptr;
		rptr_gray <= {1'b0, rptr_bin} ^ {rptr_bin, 1'b0};
	end
end

// Write pointer synchronization
always @(posedge wclk or negedge wrstn) begin
	if (!wrstn)
		wptr_syn <= 0;
	else
		wptr_syn <= rptr_buff;
end

// Read pointer synchronization
always @(posedge rclk or negedge rrstn) begin
	if (!rrstn)
		rptr_syn <= 0;
	else
		rptr_syn <= wptr_buff;
end

// Write enable logic
wire wen;
assign wen = !wfull;

// Read data valid logic
wire rdata_valid;
assign rdata_valid = !rempty;

// Full and empty signals
assign wfull = (wptr_syn == ~{rptr_gray[ADDR_WIDTH-1], rptr_gray[ADDR_WIDTH-2:1]});
assign rempty = (rptr_syn == wptr_gray);

endmodule