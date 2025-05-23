Please complete the Verilog code below and return the complete module code directly:
```verilog
module multi_pipe_4bit#(
	parameter size = 4
)(
	input 						clk 		,   
	input 						rst_n		,
	input	[size-1:0]			mul_a		,
	input	[size-1:0]			mul_b		,
 
 	output	reg	[size*2-1:0]	mul_out		
);

parameter N = 2 * size;

wire [size:0] 	mul_a_ext;
wire [size:0] 	mul_b_ext;
wire [N-1:0] 	pp_stage1 [size-1:0];
wire [N-1:0] 	pp_stage2 [size-1:0];
wire [N-1:0] 	pp_stage3 [size-1:0];
wire [N-1:0] 	pp_stage4 [size-1:0];
wire [N-1:0] 	pp_stage5 [size-1:0];
wire [N-1:0] 	sum_reg_stage1 [size-1:0];
wire [N-1:0] 	sum_reg_stage2 [size-1:0];
wire [N-1:0] 	sum_reg_stage3 [size-1:0];
wire [N-1:0] 	sum_reg_stage4 [size-1:0];
wire [N-1:0] 	sum_reg_stage5 [size-1:0];

assign mul_a_ext = {1'b0, mul_a};
assign mul_b_ext = {1'b0, mul_b};

genvar i;
generate
	for (i = 0; i < size; i = i + 1) begin : gen_partial_product
		assign pp_stage1[i] = mul_a_ext[i] ? {{(N-size){mul_b_ext[0]}}, mul_b_ext} : 'd0;
		assign pp_stage2[i] = mul_a_ext[i] ? {{(N-size){mul_b_ext[1]}}, mul_b_ext[0:size-1]} : 'd0;
		assign pp_stage3[i] = mul_a_ext[i] ? {{(N-size){mul_b_ext[2]}}, mul_b_ext[1:size-1]} : 'd0;
		assign pp_stage4[i] = mul_a_ext[i] ? {{(N-size){mul_b_ext[3]}}, mul_b_ext[2:size-1]} : 'd0;
		assign pp_stage5[i] = mul_a_ext[i] ? {{(N-size){mul_b_ext[4]}}, mul_b_ext[3:size-1]} : 'd0;
	end
endgenerate

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		sum_reg_stage1[0] <= 0;
		sum_reg_stage1[1] <= 0;
		sum_reg_stage1[2] <= 0;
		sum_reg_stage1[3] <= 0;
	end else begin
		sum_reg_stage1[0] <= pp_stage1[0];
		sum_reg_stage1[1] <= pp_stage1[1] + pp_stage2[0];
		sum_reg_stage1[2] <= pp_stage1[2] + pp_stage2[1] + pp_stage3[0];
		sum_reg_stage1[3] <= pp_stage1[3] + pp_stage2[2] + pp_stage3[1] + pp_stage4[0];
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		sum_reg_stage2[0] <= 0;
		sum_reg_stage2[1] <= 0;
		sum_reg_stage2[2] <= 0;
		sum_reg_stage2