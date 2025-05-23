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

// Registers to store intermediate sums
reg [N-1:0] partial_sum;
reg [N-1:0] final_sum;

// Extended multiplicand and multiplier
wire [N-1:0] extended_a = {size{1'b0}}, extended_b = {size{1'b0}};

// Generate block to calculate partial products
genvar i;
generate
	for (i = 0; i < size; i = i + 1) begin : partial_product_gen
		assign partial_sum[i] = (mul_b[i] == 1'b1) ? (extended_a << i) : 'd0;
	end
endgenerate

// Pipeline registers for intermediate sums
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		partial_sum <= 'd0;
		final_sum <= 'd0;
	end else begin
		// Sum the partial products
		final_sum <= partial_sum + final_sum;
	end
end

// Output register for final product
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= 'd0;
	end else begin
		mul_out <= final_sum;
	end
end

endmodule