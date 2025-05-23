// Dual Port RAM
reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

always @(posedge wclk or negedge wrstn) begin
	if (!wrstn)
		waddr_bin <= 0;
	else if (winc)
		waddr_bin <= waddr_bin + 1'b1;
end

always @(posedge rclk or negedge rrstn) begin
	if (!rrstn)
		raddr_bin <= 0;
	else if (rinc)
		raddr_bin <= raddr_bin + 1'b1;
end

// Write and Read Pointers
wire [ADDR_WIDTH-1:0] wptr = waddr_bin[ADDR_WIDTH-1:0];
wire [ADDR_WIDTH-1:0] rptr = raddr_bin[ADDR_WIDTH-1:0];

reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;

always @(posedge wclk or negedge wrstn) begin
	if (!wrstn)
		wptr_buff <= 0;
	else
		wptr_buff <= wptr;
end

always @(posedge rclk or negedge rrstn) begin
	if (!rrstn)
		rptr_buff <= 0;
	else
		rptr_buff <= rptr;
end

// Gray Code Conversion
wire [ADDR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
wire [ADDR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);

// Full and Empty Signals
wire wfull = (wptr_gray[ADDR_WIDTH-1:1] == rptr_gray[ADDR_WIDTH-1:1]) && (wptr_gray[0] != rptr_gray[0]);
wire rempty = (wptr_gray == rptr_gray);

// Dual Port RAM
wire wen = winc & ~wfull;
wire ren = rinc & ~rempty;

assign rdata = ram_mem[raddr_bin];

always @(posedge wclk or negedge wrstn) begin
	if (!wrstn)
		ram_mem <= '{default:0};
	else if (wen)
		ram_mem[waddr_bin] <= wdata;
end

endmodule