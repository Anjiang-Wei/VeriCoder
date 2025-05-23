```verilog
reg [ADDR_WIDTH-1:0] wptr_bin, rptr_bin, wptr_buff, rptr_buff;
reg [ADDR_WIDTH-1:0] rptr_syn;
wire [ADDR_WIDTH-1:0] wptr, rptr;

dual_port_RAM #(
	.DEPTH(DEPTH),
	.WIDTH(WIDTH)
) RAM(
	.wclk(wclk),
	.wenc(winc),
	.waddr(wptr),
	.wdata(wdata),
	.rclk(rclk),
	.renc(winc),
	.raddr(rptr),
	.rdata(rdata)
);

assign wfull = (wptr == (rptr ^ {(ADDR_WIDTH){1'b1}}));
assign rempty = (wptr == rptr);

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

always @(posedge wclk or negedge wrstn) begin
	if (!wrstn) begin
		wptr_bin <= 0;
	end else begin
		wptr_bin <= wptr ^ (wptr >> 1);
	end
end

always @(posedge rclk or negedge rrstn) begin
	if (!rrstn) begin
		rptr_bin <= 0;
	end else begin
		rptr_bin <= rptr ^ (rptr >> 1);
	end
end

always @(posedge wclk) begin
	wptr <= wptr + winc;
end

always @(posedge rclk) begin
	rptr <= rptr + rinc;
end

always @(posedge wclk) begin
	if (winc && wptr_buff == rptr_buff) begin
		wfull <= 1;
	end else begin
		wfull <= 0;
	end
end

always @(posedge rclk) begin
	if (rinc && wptr_bin == rptr_bin) begin
		rempty <= 1;
	end else begin
		rempty <= 0;
	end
end

always @(posedge wclk) begin
	if (winc && wptr_buff == rptr_buff) begin
		wfull <= 1;
	end else begin
		wfull <= 0;
	end
end

always @(posedge rclk) begin
	if (rinc && wptr_bin == rptr_bin) begin
		rempty <= 1;
	end else begin
		rempty <= 0;
	end
end

endmodule