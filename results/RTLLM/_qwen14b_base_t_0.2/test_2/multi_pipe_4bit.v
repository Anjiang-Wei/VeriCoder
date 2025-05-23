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

// Intermediate registers
reg [size*2-1:0] partial_product;
reg [size*2-1:0] intermediate_sum;

// Extended multiplicand and multiplier
wire [N-1:0] extended_a = {size{mul_a[size-1]}, mul_a};
wire [N-1:0] extended_b = {size{mul_b[size-1]}, mul_b};

// Generate block for partial products
genvar i;
generate
	for (i = 0; i < size; i = i + 1) begin : partial_product_gen
		assign partial_product[i] = (mul_b[i] == 1'b1) ? extended_a << i : 'd0;
	end
endgenerate

// Pipeline registers
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		intermediate_sum <= 'd0;
		mul_out <= 'd0;
	end else begin
		// First stage: Add partial products
		for (i = 0; i < size; i = i + 1) begin
			intermediate_sum = intermediate_sum + partial_product[i];
		end
		
		// Second stage: Final product calculation
		mul_out <= intermediate_sum;
	end
end

endmodule