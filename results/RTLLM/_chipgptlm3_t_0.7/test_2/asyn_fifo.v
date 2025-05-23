wire [WIDTH-1:0] rdata;
reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
reg [WIDTH-1:0] wptr, rptr;
reg [WIDTH-1:0] wptr_buff, rptr_buff;
reg [ADDR_WIDTH-1:0] wptr_syn, rptr_syn;
wire wfull, rempty;

assign wfull = (wptr_syn[ADDR_WIDTH-1] ^ wptr_syn[ADDR_WIDTH-2]) & wptr_syn[ADDR_WIDTH-1] & wptr_syn[ADDR_WIDTH-2] & wptr_syn[ADDR_WIDTH-3] & wptr_syn[ADDR_WIDTH-4] & wptr_syn[ADDR_WIDTH-5] & wptr_syn[ADDR_WIDTH-6] & wptr_syn[ADDR_WIDTH-7] & wptr_syn[ADDR_WIDTH-8] & wptr_syn[ADDR_WIDTH-9];
assign rempty = (rptr_syn[ADDR_WIDTH-1] ^ rptr_syn[ADDR_WIDTH-2]) & rptr_syn[ADDR_WIDTH-1] & rptr_syn[ADDR_WIDTH-2] & rptr_syn[ADDR_WIDTH-3] & rptr_syn[ADDR_WIDTH-4] & rptr_syn[ADDR_WIDTH-5] & rptr_syn[ADDR_WIDTH-6] & rptr_syn[ADDR_WIDTH-7] & rptr_syn[ADDR_WIDTH-8] & rptr_syn[ADDR_WIDTH-9];

assign rdata = (wfull & rempty)? wdata : RAM_MEM[raddr_bin];

// write pointer
always @(posedge wclk or negedge wrstn) begin
	if (~wrstn) begin
		wptr <= 0;
		wptr_buff <= 0;
	end
	else if (winc) begin
		wptr <= wptr + 1;
		wptr_buff <= wptr;
	end
end

// read pointer
always @(posedge rclk or negedge rrstn) begin
	if (~rrstn) begin
		rptr <= 0;
		rptr_buff <= 0;
	end
	else if (rinc) begin
		rptr <= rptr + 1;
		rptr_buff <= rptr;
	end
end

// pointer synchronizer
always @(posedge wclk or posedge rclk) begin
	if (wfull & rempty) begin
		wptr_syn <= wptr;
		rptr_syn <= rptr;
	end
end

always @(posedge rclk) begin
	if (!rrstn) begin
		wptr_syn <= 0;
	end
end

always @(posedge wclk) begin
	if (!wrstn) begin
		rptr_syn <= 0;
	end
end

endmodule

module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input wclk,
	input wenc,
	input [$clog2(DEPTH)-1:0] waddr,
	input [WIDTH-1:0] wdata,
	input rclk,
	input renc,
	input [$clog2(DEPTH)-1:0] raddr,
	output reg [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] RAM_MEM[0:DEPTH-1];

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

endmodule