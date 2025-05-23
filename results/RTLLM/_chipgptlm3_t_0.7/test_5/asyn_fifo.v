verilog
reg [WIDTH-1:0] rdata;
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] waddr;
reg [ADDR_WIDTH-1:0] raddr;
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_syn;
reg [ADDR_WIDTH-1:0] rptr_syn;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;
reg [ADDR_WIDTH-1:0] wptr_gray_buff;
reg [ADDR_WIDTH-1:0] rptr_gray_buff;
reg [ADDR_WIDTH-1:0] wptr_gray_syn;
reg [ADDR_WIDTH-1:0] rptr_gray_syn;
reg wfull;
reg rempty;
reg [ADDR_WIDTH-1:0] waddr_syn;
reg [ADDR_WIDTH-1:0] raddr_syn;
reg [ADDR_WIDTH-1:0] wptr_syn_next;
reg [ADDR_WIDTH-1:0] rptr_syn_next;
reg [ADDR_WIDTH-1:0] waddr_syn_next;
reg [ADDR_WIDTH-1:0] raddr_syn_next;
reg winc_reg;
reg rinc_reg;
reg wdata_reg;
reg wren;
reg ren;
reg wfull_reg;
reg rempty_reg;

assign wfull = wfull_reg;
assign rempty = rempty_reg;
assign rdata = rdata_reg;

always @(posedge wclk) begin
	winc_reg <= winc;
	waddr_syn <= waddr_syn_next;
	waddr_syn_next <= waddr_syn + 1'b1;
end

always @(posedge rclk) begin
	rinc_reg <= rinc;
	raddr_syn <= raddr_syn_next;
	raddr_syn_next <= raddr_syn + 1'b1;
end

assign wren = (winc_reg & ~wfull_reg) | (winc_reg & rempty_reg);
assign ren = (rinc_reg & ~rempty_reg) | (rinc_reg & wfull_reg);

always @(posedge wclk) begin
	if (~wrstn) begin
		waddr_bin <= 0;
		wptr <= 0;
		wptr_buff <= 0;
	end else begin
		waddr_bin <= waddr_bin + 1'b1;
		wptr <= wptr + 1'b1;
		wptr_buff <= wptr;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		raddr_bin <= 0;
		rptr <= 0;
		rptr_buff <= 0;
	end else begin
		raddr_bin <= raddr_bin + 1'b1;
		rptr <= rptr + 1'b1;
		rptr_buff <= rptr;
	end
end

always @(posedge wclk) begin
	if (~wrstn) begin
		wptr_gray <= 0;
	end else begin
		wptr_gray <= wptr_bin_gray(wptr);
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		rptr_gray <= 0;
	end else begin
		rptr_gray <= rptr_bin_gray(rptr);
	end
end

always @(posedge wclk) begin
	if (~wrstn) begin
		wptr_gray_buff <= 0;
	end else begin
		wptr_gray_buff <= wptr_gray;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		rptr_gray_buff <= 0;
	end else begin
		rptr_gray_buff <= rptr_gray;
	end
end

always @(posedge wclk) begin
	if (~wrstn) begin
		wptr_syn <= 0;
	end else begin
		wptr_syn <= wptr;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		rptr_syn <= 0;
	end else begin
		rptr_syn <= rptr;
	end
end

always @(posedge wclk) begin
	if (~wrstn) begin
		waddr_syn <= 0;
	end else begin
		waddr_syn <= waddr_bin;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		raddr_syn <= 0;
	end else begin
		raddr_syn <= raddr_bin;
	end
end

always @(posedge wclk) begin
	if (~wrstn) begin
		w