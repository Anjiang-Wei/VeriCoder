module asyn_fifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					wclk	, 
	input 					rclk	,   
	input 					wrstn	,
	input					rrstn	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output wire				wfull	,
	output wire				rempty	,
	output wire [WIDTH-1:0]	rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

module dual_port_RAM#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					wclk	, 
	input					wrstn,
	input 					waddr	[ADDR_WIDTH-1:0],
	input 					wdata	[WIDTH-1:0],
	input 					wenc	,
	output reg [WIDTH-1:0]	wqout,

	input 					rclk	,   
	input					rrstn,
	input 					raddr	[ADDR_WIDTH-1:0],
	output wire [WIDTH-1:0]	rdata
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge wclk) begin
	if (~wrstn)
		RAM_MEM <= '{default : 8'd0};
	else if (wenc) begin
		RAM_MEM[waddr] <= wdata;
	end
end

always @(posedge rclk) begin
	if (~rrstn)
		rdata <= {WIDTH{1'b0}};
	else if (renc) begin
		rdata <= RAM_MEM[raddr];
	end
end

endmodule // dual_port_RAM

reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;

wire [$clog2(DEPTH)-1:0] wptr_syn, rptr_syn;

always @(posedge wclk) begin
	if (~wrstn)
		waddr_bin <= 0;
	else if (winc)
		waddr_bin <= waddr_bin + 1'd1;
end

always @(posedge rclk) begin
	if (~rrstn)
		raddr_bin <= 0;
	else if (rinc)
		raddr_bin <= raddr_bin + 1'd1;
end

reg [$clog2(DEPTH)-1:0] wptr, rptr;

wire [ADDR_WIDTH-1:0] wptr_gray, rptr_gray;

always @(posedge wclk) begin
	wptr <= (waddr_bin[ADDR_WIDTH-1]) ^ {(ADDR_WIDTH-2){~(waddr_bin[ADDR_WIDTH-2])}};
end

always @(posedge rclk) begin
	rptr <= (raddr_bin[ADDR_WIDTH-1]) ^ {(ADDR_WIDTH-2){~(raddr_bin[ADDR_WIDTH-2])}};
end

always @* begin
	wptr_gray = {wptr, wptr};
	rptr_gray = {rptr, rptr};

	wptr_syn = $signed(wptr_gray)[$clog2(DEPTH)-1:$clog2(DEPTH)-$clog2(ADDR_WIDTH)];
	rptr_syn = $signed(rptr_gray)[$clog2(DEPTH)-1:$clog2(DEPTH)-$clog2(ADDR_WIDTH)];

	wptr_buff <= wptr_syn;
	rptr_buff <= rptr_syn;

	end

reg wen, ren;

always @* begin
	wen = winc & ~wfull;
	ren = rinc & ~rempty;
end

wire [WIDTH-1:0] wqout;

module dual_port_RAM_instance(
	.wclk(wclk),
	.wrstn(wrstn),
	.waddr(wptr_syn),
	.wdata(wdata),
	.wenc(wen),
	.wo(wqout),

	.rclk(rclk),
	.rrstn(rrstn),
	.raddr(rptr_syn),
	.ro(rdata)
);

endmodule // dual_port_RAM_instance

reg [WIDTH-1:0] data_out;

always @* begin
	data_out = (wen & wptr_syn[ADDR_WIDTH-1]) ? wqout : 8'd0;
	end

wire [$clog2(DEPTH)-1:0] waddr_gray, raddr_gray;

assign wfull = ($signed({1'b0, wptr_buff}) == $signed({~rptr_buff}));
assign rempty = (wptr_buff == rptr_buff);

endmodule // asyn_fifo