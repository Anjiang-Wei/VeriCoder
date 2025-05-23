verilog
reg [WIDTH-1:0] rdata;

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn;

reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] wptr_sync;
reg [$clog2(DEPTH)-1:0] rptr_sync;
reg [WIDTH-1:0] wdata;
reg [WIDTH-1:0] wdata_sync;

reg [WIDTH-1:0] rdata_sync;

wire wfull;
wire rempty;
wire wen;
wire ren;

assign wen = (wptr_syn < rptr_syn)? 1'b1 : 1'b0;
assign ren = (rptr_syn < wptr_syn)? 1'b1 : 1'b0;

assign rdata = rdata_sync;

always @(posedge wclk) begin
	if(~wrstn) begin
		waddr_bin <= 0;
		wptr <= 0;
		wptr_syn <= 0;
		wptr_buff <= 0;
		wptr_sync <= 0;
		wdata_sync <= 0;
	end else begin
		waddr_bin <= waddr_bin + 1;
		wptr <= wptr + winc;
		wptr_syn <= wptr_syn + wen;
		wptr_sync <= wptr_buff;
		wptr_buff <= wptr;
		wdata_sync <= wdata;
	end
end

always @(posedge rclk) begin
	if(~rrstn) begin
		raddr_bin <= 0;
		rptr <= 0;
		rptr_syn <= 0;
		rptr_buff <= 0;
		rdata_sync <= 0;
	end else begin
		raddr_bin <= raddr_bin + 1;
		rptr <= rptr + rinc;
		rptr_syn <= rptr_syn + ren;
		rptr_sync <= rptr_buff;
		rdata_sync <= rdata;
	end
end

assign wfull = (rptr_syn + 1'b1 == wptr_syn)? 1'b1 : 1'b0;
assign rempty = (rptr_syn == wptr_syn)? 1'b1 : 1'b0;

assign wdata = wdata_sync;

always @(posedge wclk) begin
	if(wrstn) begin
		wptr <= 0;
	end else begin
		wptr <= wptr + winc;
	end
end

always @(posedge rclk) begin
	if(rrstn) begin
		rptr <= 0;
	end else begin
		rptr <= rptr + rinc;
	end
end

always @(posedge wclk) begin
	wptr_syn <= wptr_syn + wen;
end

always @(posedge rclk) begin
	rptr_syn <= rptr_syn + ren;
end

always @(posedge wclk) begin
	wptr_sync <= wptr_buff;
end

always @(posedge rclk) begin
	rptr_sync <= rptr_buff;
end

endmodule

module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 	wclk	, 
	input 	rclk	,   
	input 	wrstn	,
	input		wenc	,
	input	[WIDTH-1:0] wdata	,
	input 		renc	,
	output reg [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

reg [ADDR_WIDTH-1:0] waddr;
reg [ADDR_WIDTH-1:0] raddr;

reg [ADDR_WIDTH-1:0] waddr_sync;
reg [ADDR_WIDTH-1:0] raddr_sync;

reg wenc_sync;
reg renc_sync;

reg [WIDTH-1:0] wdata_sync;
reg [WIDTH-1:0] rdata_sync;

assign rdata = rdata_sync;

always @(posedge wclk) begin
	if(~wrstn) begin
		waddr <= 0;
		wenc_sync <= 0;
		wdata_sync <= 0;
	end else begin
		waddr <= waddr + 1;
		wenc_sync <= wenc;
		wdata_sync <= wdata;
	end
end

always @(posedge rclk)