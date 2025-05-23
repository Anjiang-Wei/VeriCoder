// Gray code conversion
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;

always @(posedge wclk, negedge wrstn) begin
	if(!wrstn) begin
		wptr <= 0;
	end else if(winc) begin
		wptr <= wptr + 1;
	end
end

always @(posedge rclk, negedge rrstn) begin
	if(!rrstn) begin
		rptr <= 0;
	end else if(rinc) begin
		rptr <= rptr + 1;
	end
end

always @(*) begin
	wptr_buff = (wptr == 0) ? 0 : wptr - 1;
	rptr_buff = (rptr == 0) ? 0 : rptr - 1;
end

// Pointer synchronizer
reg [ADDR_WIDTH-1:0] wptr_syn;
reg [ADDR_WIDTH-1:0] rptr_syn;

always @(posedge wclk, negedge wrstn) begin
	if(!wrstn) begin
		wptr_syn <= 0;
	end else begin
		wptr_syn <= wptr_buff;
	end
end

always @(posedge rclk, negedge rrstn) begin
	if(!rrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr_buff;
	end
end

// Full and empty signals
assign wfull = (wptr_syn == (~rptr_syn[ADDR_WIDTH-1:0] ^ rptr_syn[ADDR_WIDTH-2:0])) ? 1 : 0;
assign rempty = (wptr_syn == rptr_syn) ? 1 : 0;

// Dual-port RAM
dual_port_RAM#(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
) RAM(
	.wclk(wclk),
	.wenc(winc),
	.waddr(wptr_syn),
	.wdata(wdata),
	.rclk(rclk),
	.renc(rinc),
	.raddr(rptr_syn),
	.rdata(rdata)
);

endmodule