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

reg [N-1:0] partial_products [0:size-1];
reg [N-1:0] intermediate_sums [0:size-1];

initial begin
	for (int i = 0; i < size; i = i + 1) begin
		partial_products[i] = {N{1'b0}};
		intermediate_sums[i] = {N{1'b0}};
	end
	mul_out = {N{1'b0}};
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (int i = 0; i < size; i = i + 1) begin
			partial_products[i] <= {N{1'b0}};
			intermediate_sums[i] <= {N{1'b0}};
		end
		mul_out <= {N{1'b0}};
	end else begin
		// Generate partial products
		gen_partial_products: for (int i = 0; i < size; i = i + 1) begin
			if (mul_b[i]) begin
				partial_products[i] <= {{(N-size){1'b0}}, mul_a} << i;
			end else begin
				partial_products[i] <= {N{1'b0}};
			end
		end

		// Calculate intermediate sums
		gen_intermediate_sums: for (int i = 0; i < size; i = i + 1) begin
			intermediate_sums[i] <= i == 0 ? partial_products[0] : intermediate_sums[i-1] + partial_products[i];
		end

		// Calculate final product
		mul_out <= intermediate_sums[size-1];
	end
end

endmodule