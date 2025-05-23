module multi_pipe_4bit#(
	parameter size = 4
)(
	input 						clk 		,   
	input						rst_n		,
	input	[size-1:0]			mul_a		,
	input	[size-1:0]			mul_b		,
 
	output reg [size*2-1:0]		mul_out		
);

parameter N = 2 * size;

// Extension of input signals
wire [N-1:0] extended_mul_a, extended_mul_b;
assign extended_mul_a = {mul_a, {size{1'b0}}};
assign extended_mul_b = {mul_b, {size{1'b0}};

// Generate block for multiplication
generate
	for (genvar i = 0; i < size; i++) begin: gen_block_i
		reg partial_product;
		
		always @(*) begin
			partial_product = (extended_mul_b[i] == 1'b1) ? extended_mul_a : 'd0;
		end
	end
endgenerate

// Registers for intermediate sum values
reg [N-1:0] sum_reg_1, sum_reg_2;

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		sum_reg_1 <= 0;
		sum_reg_2 <= 0;
	else begin
		sum_reg_1 <= sum_reg_1 + partial_product_i[0];
		sum_reg_2 <= sum_reg_2 + partial_product_i[size-1];
	end
end

// Final product calculation
reg [size*2-1:0] mul_out_temp;

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		mul_out_temp <= 0;
	else begin
		mul_out_temp <= sum_reg_2;
	end
end

assign mul_out = mul_out_temp;

// Partial product signals for each bit position of the multiplier
wire [size-1:0] partial_product_i;

assign partial_product_i[0] = partial_product;
for (genvar i = 1; i < size; i++) begin
	assign partial_product_i[i] = (extended_mul_b[size-i-1] == 1'b1) ? extended_mul_a : 'd0;
end

endmodule