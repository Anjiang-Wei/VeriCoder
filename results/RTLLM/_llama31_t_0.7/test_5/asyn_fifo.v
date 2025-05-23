Here is the complete Verilog code for the `asyn_fifo` module:
```verilog
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
parameter DEPTH_4BIT_GRAY = 4;

wire [$clog2(DEPTH)-1:0] waddr, raddr;
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
reg [$clog2(DEPTH)-1:0] wptr_syn;

wire [$clog2(DEPTH)-1:0] wgray, rgray;
wire [WIDTH-1:0] wdata_out, rdata_out;
wire wen, ren;

reg [$clog2(DEPTH)-1:0] waddr_gray, raddr_gray;

module dual_port_RAM#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input 			wclk, 
	input 			rclk,   
	input [WIDTH-1:0]	wdata_in,  
	input [$clog2(DEPTH)-1:0] waddr,  
	input [$clog2(DEPTH)-1:0] raddr,  
	output reg [WIDTH-1:0] 	wdata_out,
	output reg [WIDTH-1:0]	rdata_out
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

initial begin
	for (int i = 0; i < DEPTH; i++) begin
		RAM_MEM[i][WIDTH-1:0] = 'bx;
	end
end

always @(posedge wclk) begin
	if (~wrstn) begin
		waddr_bin <= 0;
	end else if (winc) begin
		waddr_bin <= waddr_bin + 1;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		raddr_bin <= 0;
	end else if (rinc) begin
		raddr_bin <= raddr_bin + 1;
	end
end

always @(posedge wclk) begin
	wptr_buff <= waddr_bin;
end

always @(posedge rclk) begin
	rptr_buff <= raddr_bin;
end

reg [DEPTH_4BIT_GRAY-1:0] wgray_syn, rgray_syn;

generate
	for (genvar i = 0; i < DEPTH_4BIT_GRAY; i++) begin : gray_code_gen
		if (i == 0) begin
			wgray_syn[$clog2(DEPTH_4BIT_GRAY)-1-i] <= wptr_buff;
			rgray_syn[$clog2(DEPTH_4BIT_GRAY)-1-i] <= rptr_buff;
		end else begin
			wgray_syn[$clog2(DEPTH_4BIT_GRAY)-1-i] <= (|wgray_syn[$clog2(DEPTH_4BIT_GRAY)-i-1]);
			rgray_syn[$clog2(DEPTH_4BIT_GRAY)-1-i] <= (~rgray_syn[$clog2(DEPTH_4BIT_GRAY)-i-1]) & rgray_syn[$clog2(DEPTH_4BIT_GRAY)-i-1];
		end
	end
endgenerate

always @(posedge wclk) begin
	if (winc) begin
		waddr_gray <= wgray_syn;
		wdata_out <= RAM_MEM[waddr_bin][WIDTH-1:0];
	end else begin
		waddr_gray <= 'bx;
	end
end

always @(posedge rclk) begin
	if (rinc) begin
		raddr_gray <= rgray_syn;
		rdata_out <= RAM_MEM[raddr_bin][WIDTH-1:0];
	end else begin
		raddr_gray <= 'bx;
	end
end

assign wen = waddr_gray == waddr_bin;
assign ren = raddr_gray == raddr_bin;

always @(posedge wclk) begin
	if (~wrstn) begin
		wfull <= 0;
		rempty <= 1;
	end else if (wen) begin
		wfull <= (wgray_syn[3] & (|{wgray_syn[2:0]})) | ((~rgray_syn[3]) & (|{rgray_syn[2:0]}));
		rempty <= waddr_bin == raddr_bin;
	end else begin
		wfull <= 'bx;
		rempty <= 'bx;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		wfull <= 1;
		rempty <= 0;
	end else if (ren) begin
		wfull <= waddr_bin == raddr_bin;
		rempty <= rempty & (rgray_syn[3] & (|{rgray_syn[2:0]}));
	end else begin
		wfull <= 'bx;
		rempty <= 'bx;
	end
end

assign rdata = rdata_out;

endmodule // dual_port_RAM

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
parameter DEPTH_4BIT_GRAY = 4;

wire [$clog2(DEPTH)-1:0] waddr, raddr;
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
reg [$clog2(DEPTH)-1:0] wptr_syn;

wire [$clog2(DEPTH)-1:0] wgray, rgray;
wire [WIDTH-1:0] wdata_out, rdata_out;
wire wen, ren;

reg [$clog2(DEPTH)-1:0] waddr_gray, raddr_gray;

dual_port_RAM#(
	.parameter WIDTH = 8,
	.parameter DEPTH = 16
) dual_ram (
	.wclk(wclk),
	.rclk(rclk),   
	.wdata_in(wdata),  
	.waddr(waddr_bin),  
	.raddr(raddr_bin),  
	.wdata_out(wdata_out),
	.rdata_out(rdata_out)
);

always @(posedge wclk) begin
	if (~wrstn) begin
		waddr_bin <= 0;
	end else if (winc) begin
		waddr_bin <= waddr_bin + 1;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		raddr_bin <= 0;
	end else if (rinc) begin
		raddr_bin <= raddr_bin + 1;
	end
end

always @(posedge wclk) begin
	wptr_buff <= waddr_bin;
end

always @(posedge rclk) begin
	rptr_buff <= raddr_bin;
end

reg [DEPTH_4BIT_GRAY-1:0] wgray_syn, rgray_syn;

generate
	for (genvar i = 0; i < DEPTH_4BIT_GRAY; i++) begin : gray_code_gen
		if (i == 0) begin
			wgray_syn[$clog2(DEPTH_4BIT_GRAY)-1-i] <= wgray;
			rgray_syn[$clog2(DEPTH_4BIT_GRAY)-1-i] <= rgray;
		end else begin
			wgray_syn[$clog2(DEPTH_4BIT_GRAY)-1-i] <= (|wgray_syn[$clog2(DEPTH_4BIT_GRAY)-i-1]);
			rgray_syn[$clog2(DEPTH_4BIT_GRAY)-1-i] <= (~rgray_syn[$clog2(DEPTH_4BIT_GRAY)-i-1]) & rgray_syn[$clog2(DEPTH_4BIT_GRAY)-i-1];
		end
	end
endgenerate

assign wen = waddr_bin == wptr_syn;
assign ren = raddr_bin == rptr_syn;

always @(posedge wclk) begin
	if (~wrstn) begin
		wfull <= 0;
		rempty <= 1;
	end else if (wen) begin
		wfull <= (wgray_syn[3] & (|{wgray_syn[2:0]})) | ((~rgray_syn[3]) & (|{rgray_syn[2:0]}));
		rempty <= waddr_bin == raddr_bin;
	end else begin
		wfull <= 'bx;
		rempty <= 'bx;
	end
end

always @(posedge rclk) begin
	if (~rrstn) begin
		wfull <= 1;
		rempty <= 0;
	end else if (ren) begin
		wfull <= waddr_bin == raddr_bin;
		rempty <= rempty & (rgray_syn[3] & (|{rgray_syn[2:0]}));
	end else begin
		wfull <= 'bx;
		rempty <= 'bx;
	end
end

assign rdata = rdata_out;

endmodule // asyn_fifo