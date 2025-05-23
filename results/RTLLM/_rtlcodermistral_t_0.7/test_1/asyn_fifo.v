```verilog
reg [ADDR_WIDTH-1:0] 	wptr		;
reg [ADDR_WIDTH-1:0] 	rptr		;
reg [ADDR_WIDTH-1:0] 	wptr_buff	;
reg [ADDR_WIDTH-1:0] 	rptr_buff	;
reg [WIDTH-1:0] 		wptr_gray	;
reg [WIDTH-1:0] 		rptr_gray	;

wire [WIDTH-1:0] 		rdata_tmp	;
wire [WIDTH-1:0] 		rdata_gray	;
wire [ADDR_WIDTH-1:0] 	wptr_syn	;
wire [ADDR_WIDTH-1:0] 	rptr_syn	;
wire [ADDR_WIDTH-1:0] 	rptr_gray	;

dual_port_RAM#(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
) RAM (
	.wclk(wclk),
	.wenc(winc),
	.waddr(wptr_syn),
	.wdata(wdata),
	.rclk(rclk),
	.renc(1'b1),
	.raddr(rptr_syn),
	.rdata(rdata_tmp)
);

assign rdata = rdata_gray;
assign rdata_gray[WIDTH-1:0] = rdata_tmp[WIDTH-1:0] ^ {(ADDR_WIDTH-1){1'b0}};

assign wfull = (wptr_gray == (rptr_gray << 1) | (rptr_gray << 1) | rptr_gray);
assign rempty = (wptr_syn == rptr_syn);

always @(posedge wclk or negedge wrstn) begin
	if (~wrstn) begin
		wptr <= 0;
		wptr_buff <= 0;
	end
	else if (winc) begin
		wptr <= wptr + 1;
	end
end

always @(posedge rclk or negedge rrstn) begin
	if (~rrstn) begin
		rptr <= 0;
		rptr_buff <= 0;
	end
	else if (rinc) begin
		rptr <= rptr + 1;
	end
end

always @(posedge wclk or negedge wrstn) begin
	if (~wrstn) begin
		wptr_gray <= 0;
	end
	else begin
		wptr_gray <= wptr ^ {wptr[ADDR_WIDTH-1], (ADDR_WIDTH-1){1'b0}};
	end
end

always @(posedge rclk or negedge rrstn) begin
	if (~rrstn) begin
		rptr_gray <= 0;
	end
	else begin
		rptr_gray <= rptr ^ {rptr[ADDR_WIDTH-1], (ADDR_WIDTH-1){1'b0}};
	end
end

always @(posedge wclk or negedge wrstn) begin
	if (~wrstn) begin
		wptr_buff <= 0;
	end
	else begin
		wptr_buff <= wptr_buff ^ wptr;
	end
end

always @(posedge rclk or negedge rrstn) begin
	if (~rrstn) begin
		rptr_buff <= 0;
	end
	else begin
		rptr_buff <= rptr_buff ^ rptr;
	end
end

always @(posedge wclk or negedge wrstn) begin
	if (~wrstn) begin
		wptr_syn <= 0;
	end
	else if (winc) begin
		wptr_syn <= wptr_buff;
	end
end

always @(posedge rclk or negedge rrstn) begin
	if (~rrstn) begin
		rptr_syn <= 0;
	end
	else if (rinc) begin
		rptr_syn <= rptr_buff