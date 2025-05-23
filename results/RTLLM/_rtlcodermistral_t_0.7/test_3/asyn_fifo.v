// Dual Port RAM
dual_port_RAM#(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
)
dual_port_RAM (
	.wclk(wclk),
	.wenc(winc),
	.waddr(waddr),
	.wdata(wdata),
	.rclk(rclk),
	.renc(rinc),
	.raddr(raddr),
	.rdata(rdata)
);

reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;

always @(posedge wclk) begin
	if (~wrstn) begin
		wptr <= 0;
		waddr_bin <= 0;
	end else begin
		if (winc) begin
			wptr <= wptr + 1;
		end
		waddr_bin <= wptr ^ (wptr >> 1);
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		rptr <= 0;
		raddr_bin <= 0;
	end else begin
		if (rinc) begin
			rptr <= rptr + 1;
		end
		raddr_bin <= rptr ^ (rptr >> 1);
	end
end

assign wfull = (wptr == ~rptr_syn[ADDR_WIDTH-1:1]);
assign rempty = (wptr == rptr);

always @(posedge wclk, posedge rclk) begin
	if (~wrstn) begin
		wptr_buff <= 0;
	end else begin
		if (winc) begin
			wptr_buff <= wptr;
		end
	end
	
	if (~rrstn) begin
		rptr_buff <= 0;
	end else begin
		if (rinc) begin
			rptr_buff <= rptr;
		end
	end
end

always @(posedge wclk, posedge rclk) begin
	if (wfull) begin
		rptr <= rptr_buff;
	end
	
	if (rempty) begin
		wptr <= wptr_buff;
	end
end

endmodule