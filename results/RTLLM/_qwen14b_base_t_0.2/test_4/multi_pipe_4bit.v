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
reg [size-1:0] mul_a_ext;
reg [size-1:0] mul_b_ext;
reg [N-1:0] partial_product;
reg [N-1:0] intermediate_sum;
reg [N-1:0] final_product;

// Extend the input signals by adding 'size' number of zero bits at the most significant bit positions
always @(*) begin
	mul_a_ext = {size{1'b0}} << size | mul_a;
	mul_b_ext = {size{1'b0}} << size | mul_b;
end

// Generate block to perform multiplication for each bit position of the multiplier (mul_b)
generate
	genvar i;
	for (i = 0; i < size; i = i + 1) begin : gen_pp
		assign partial_product[i] = (mul_b_ext[i] == 1'b1) ? mul_a_ext << i : 'd0;
	end
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		intermediate_sum <= 'd0;
	end else begin
		// Sum the partial products
		intermediate_sum <= intermediate_sum + partial_product;
	end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		final_product <= 'd0;
	end else begin
		// Update the final product with the intermediate sum
		final_product <= intermediate_sum;
	end
end

// Assign the final product to the output
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= 'd0;
	end else begin
		// Output the final product
		mul_out <= final_product;
	end
end

endmodule