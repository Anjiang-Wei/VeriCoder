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
reg [N-1:0] partial_product;
reg [N-1:0] intermediate_sum;
reg [N-1:0] final_sum;

// Extend the input signals by adding 'size' number of zero bits at the most significant bit positions
wire [N-1:0] extended_a = {size{1'b0}}, extended_a_shifted;
wire [N-1:0] extended_b = {size{1'b0}}, extended_b_shifted;

// Generate block to perform multiplication for each bit position of the multiplier (mul_b)
generate
	genvar i;
	for (i = 0; i < size; i = i + 1) begin : gen_pp
		assign extended_a_shifted = extended_a << i;
		assign extended_b_shifted = extended_b << i;
		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				partial_product <= 'b0;
			end else if (mul_b[i] == 1'b1) begin
				partial_product <= extended_a_shifted;
			end else begin
				partial_product <= 'b0;
			end
		end
	end
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		intermediate_sum <= 'b0;
	end else begin
		intermediate_sum <= intermediate_sum + partial_product;
	end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		final_sum <= 'b0;
	end else begin
		final_sum <= intermediate_sum;
	end
end

// Assign the final product to the output
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= 'b0;
	end else begin
		mul_out <= final_sum;
	end
end

endmodule