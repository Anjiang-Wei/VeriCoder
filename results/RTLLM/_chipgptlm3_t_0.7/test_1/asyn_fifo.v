verilog
// Instantiate dual-port RAM module
dual_port_RAM#(
	parameter ADDR_WIDTH = ADDR_WIDTH,
	parameter WIDTH = WIDTH
)(
	.wclk(wclk),
	.wrstn(wrstn),
	.waddr(waddr),
	.wdata(wdata),
	.wenc(wen),
	.rclk(rclk),
	.renc(ren),
	.raddr(raddr),
	.rdata(rdata)
);
reg [WIDTH-1:0] rdata;
reg [ADDR_WIDTH-1:0] waddr, raddr;
reg wen, ren;
wire [WIDTH-1:0] wdata;

// Data Write Controller
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] wptr_syn;
always @(posedge wclk) begin
	wptr_buff <= wptr;
end

assign wptr_syn = wptr ^ (wptr >> 1);

assign wfull = (wptr_syn == ~rptr_syn);

always @(posedge wclk) begin
	if (~wrstn) begin
		wptr <= 0;
	end else if (winc) begin
		wptr <= wptr + 1;
	end
end

always @(posedge wclk) begin
	if (wfull) begin
		wen <= 0;
	end else begin
		wen <= 1;
	end
end

always @(posedge wclk) begin
	if (wen) begin
		rdata <= wdata;
	end
end

// Data Read Controller
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] rptr_buff;
reg [ADDR_WIDTH-1:0] rptr_syn;
always @(posedge rclk) begin
	rptr_buff <= rptr;
end

assign rptr_syn = rptr ^ (rptr >> 1);

assign rempty = (rptr_syn == wptr_syn);

always @(posedge rclk) begin
	if (~rrstn) begin
		rptr <= 0;
	end else if (rinc) begin
		rptr <= rptr + 1;
	end
end

always @(posedge rclk) begin
	if (rempty) begin
		ren <= 0;
	end else begin
		ren <= 1;
	end
end

always @(posedge rclk) begin
	if (ren) begin
		raddr <= rptr;
	end
end

endmodule

// Dual-port RAM module
module dual_port_RAM#(
	parameter ADDR_WIDTH = ADDR_WIDTH,
	parameter WIDTH = WIDTH
)(
	input wclk, wrstn,
	input [ADDR_WIDTH-1:0] waddr,
	input [WIDTH-1:0] wdata,
	input wenc,
	input rclk, renc,
	input [ADDR_WIDTH-1:0] raddr,
	output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] ram_mem[0:DEPTH-1];
reg [ADDR_WIDTH-1:0] waddr_reg, raddr_reg;
reg wenc_reg, ren_reg;
wire [WIDTH-1:0] wdata_reg;
wire [WIDTH-1:0] rdata_reg;

always @(posedge wclk) begin
	if (~wrstn) begin
		waddr_reg <= 0;
		wenc_reg <= 0;
	end else if (wenc) begin
		waddr_reg <= waddr;
		wenc_reg <= wenc;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		raddr_reg <= 0;
		ren_reg <= 0;
	end else if (renc) begin
		raddr_reg <= raddr;
		ren_reg <= ren;
	end
end

always @(posedge wclk) begin
	if (wenc_reg) begin
		ram_mem[waddr_reg] <= wdata;
	end
end

always @(posedge rclk) begin
	if (renc) begin
		rdata <= ram_mem[raddr_reg];
	end
end

endmodule
```