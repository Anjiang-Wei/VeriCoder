module multi_pipe_4bit#(
	parameter size = 4
)(
	input 						clk 		,   
	input 						rst_n		,
	input	[size-1:0]			mul_a		,
	input	[size-1:0]			mul_b		,
 
 	output reg	[2*size-1:0]	mul_out		
);

parameter N = 2 * size;

reg [size-1:0] ext_mul_a, ext_mul_b;
reg [size-1:0] sum_reg1, sum_reg2;
reg [N-1:0] partial_products;

// Extend input signals
always @* begin
	ext_mul_a = mul_a << (size - 1);
	ext_mul_b = {mul_b[size-1], mul_b[size-2:size]};
end

generate for (genvar i = 0; i < size; i++) begin : gen_partial_products
	reg partial_product;

	always @* begin
		if(ext_mul_b[i]) 
			partial_products[(i+size)*size +: size] = ext_mul_a;
		else
			partial_products[(i+size)*size +: size] = 'd0;
	end
end

// Store intermediate sum values in registers
always @(posedge clk or negedge rst_n) begin
	if (~rst_n)
		sum_reg1 <= 'd0;
	else
		sum_reg1 <= {sum_reg2, partial_products[size*size-1:0]};
end

always @(posedge clk or negedge rst_n) begin
	if (~rst_n)
		sum_reg2 <= 'd0;
	else
		sum_reg2 <= sum_reg1 + sum_reg2;
end

// Calculate final product on falling edge of reset signal
always @* begin
	if(~rst_n)
		mul_out = 'd0;
	else
		mul_out = {sum_reg1[size*size-1:0], sum_reg2};
end
endmodule