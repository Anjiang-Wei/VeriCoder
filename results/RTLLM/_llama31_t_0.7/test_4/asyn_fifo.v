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
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input 	logic 	 clk_w,  
	input 	logic 	 rstn_w,  
	input 	logic [ADDR_WIDTH-1:0] addr_w,  
	input 	logic [WIDTH-1:0] data_w,  
	input 	logic 	 we_w,  

	input 	logic 	 clk_r,  
	input 	logic 	 rstn_r,  
	input 	logic [ADDR_WIDTH-1:0] addr_r,  
	output logic [WIDTH-1:0] data_r
);

reg [WIDTH-1:0] RAM_MEM[DEPTH-1:0];

always_ff @(posedge clk_w or posedge rstn_w) begin
	if (~rstn_w) begin
		RAM_MEM <= '{DEFAULT_VALUE};
	end else if (we_w) begin
		RAM_MEM[addr_w] <= data_w;
	end
end

always_comb begin
	data_r = RAM_MEM[addr_r];
end

endmodule // dual_port_RAM

reg [$clog2(DEPTH)-1:0] wptr, rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;

always_ff @(posedge wclk or posedge ~wrstn) begin
	if (~~wrstn) begin
		wptr <= 0;
	end else if (winc) begin
		wptr <= wptr + 1;
	end

	wptr_buff <= wptr;
end

always_ff @(posedge rclk or posedge ~rrstn) begin
	if (~~rrstn) begin
		rptr <= 0;
	end else if (rinc) begin
		rptr <= rptr + 1;
	end

	rptr_buff <= rptr;
end

reg [$clog2(DEPTH)-1:0] wptr_syn, rptr_syn;

always_ff @(posedge wclk) begin
	wptr_syn <= ^{(wptr[ADDR_WIDTH-2:0])};
end

always_ff @(posedge rclk) begin
	rptr_syn <= ^{(rptr[ADDR_WIDTH-2:0])};
end

reg [WIDTH-1:0] wdata_ram, rdata_ram;

assign wen = (wfull == 1'b0);
assign ren = (rempty == 1'b0);

always_comb begin
	if (wen) begin
		wdata_ram <= wdata;
	end else begin
		wdata_ram <= RAM_MEM[wptr_syn];
	end

	if (ren) begin
		rdata_ram <= rdata;
	end else begin
		rdata_ram <= RAM_MEM[rptr_syn];
	end
end

always_ff @(posedge wclk or posedge ~wrstn) begin
	if (~~wrstn) begin
		wfull <= 1'b0;
	end else if (wen && (wptr_syn == ^{(rptr_syn[ADDR_WIDTH-2:0])} | rptr_syn)) begin
		wfull <= 1'b1;
	end else begin
		wfull <= wfull;
	end

end

always_ff @(posedge rclk or posedge ~rrstn) begin
	if (~~rrstn) begin
		rempty <= 1'b0;
	end else if (ren && (rptr_syn == wptr_syn)) begin
		rempty <= 1'b1;
	end else begin
		rempty <= rempty;
	end

end

always_comb begin
	rdata = ren ? rdata_ram : {DEFAULT_VALUE};
end

dual_port_RAM dpram(
	.clk_w(wclk),
	.rstn_w(~wrstn),
	.addr_w(wptr_syn),
	.data_w(wdata_ram),
	.we_w(wen),

	.clk_r(rclk),
	.rstn_r(~rrstn),
	.addr_r(rptr_syn),
	.data_r(rdata_ram)
);

endmodule // asyn_fifo