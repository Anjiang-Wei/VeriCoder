module dual_port_RAM#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					wclk	,
	input 					rclk	,
	input 					wenc	,
	input 					renc	,
	input 	[ADDR_WIDTH-1:0]	waddr	,
	input 	[ADDR_WIDTH-1:0]	raddr	,
	input 	[WIDTH-1:0]		wdata	,
	output reg [WIDTH-1:0]	rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc) begin
		RAM_MEM[waddr] <= wdata;
	end
end

always @(posedge rclk) begin
	if(renc) begin
		rdata <= RAM_MEM[raddr];
	end
end

endmodule
```

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

// Dual-port RAM
dual_port_RAM #(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
) dual_port_RAM_inst (
	.wclk(wclk),
	.rclk(rclk),
	.wenc(wen),
	.renc(ren),
	.waddr(waddr),
	.raddr(raddr),
	.wdata(wdata),
	.rdata(rdata)
);

// Write and Read Pointers
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

always @(posedge wclk or negedge wrstn) begin
	if(~wrstn) begin
		waddr_bin <= 0;
	end else if(winc) begin
		waddr_bin <= waddr_bin + 1;
	end
end

always @(posedge rclk or negedge rrstn) begin
	if(~rrstn) begin
		raddr_bin <= 0;
	end else if(rinc) begin
		raddr_bin <= raddr_bin + 1;
	end
end

// Gray Code Conversion
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

always @(posedge wclk or negedge wrstn) begin
	if(~wrstn) begin
		wptr <= 0;
	end else if(winc) begin
		wptr <= wptr ^ (wptr >> 1);
	end
end

always @(posedge rclk or negedge rrstn) begin
	if(~rrstn) begin
		rptr <= 0;
	end else if(rinc) begin
		rptr <= rptr ^ (rptr >> 1);
	end
end

// Pointer Buffers
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;

always @(posedge wclk or negedge wrstn) begin
	if(~wrstn) begin
		wptr_buff <= 0;
	end else begin
		wptr_buff <= wptr;
	end
end

always @(posedge rclk or negedge rrstn) begin
	if(~rrstn) begin
		rptr_buff