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

// Internal signals and registers
reg [N-1:0] partial_product [0:size-1];
reg [N-1:0] sum_reg;

// Function to extend the multiplicand by size bits
function [N-1:0] extend_multiplicand;
	input [size-1:0] a;
begin
	extend_multiplicand = {a, {size{1'b0}}};
end
endfunction

// Generate block to calculate partial products
generate
	genvar i;
	for (i = 0; i < size; i = i + 1) begin
		assign partial_product[i] = (mul_b[i] == 1'b1) ? extend_multiplicand(mul_a) << i : 'd0;
	end
endgenerate

// Pipeline registers for summing partial products
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		sum_reg <= 'd0;
		mul_out <= 'd0;
	end else begin
		// Sum partial products
		for (i = 0; i < size; i = i + 1) begin
			sum_reg = sum_reg + partial_product[i];
		end
		// Assign final product to output
		mul_out <= sum_reg;
	end
end

endmodule