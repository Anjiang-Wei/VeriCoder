module multi_pipe_4bit #(
	parameter size = 4
)(
	input 					clk 		,   
	input 					rst_n		,
	input	[size-1:0]		mul_a		,
	input	[size-1:0]		mul_b		,
 	output	reg	[size*2-1:0]	mul_out		
);

	parameter N = 2 * size;

	// Internal signals: registers for pipeline stages and shifts
	reg [N-1:0] partial_products [0:size-1]; // Array to store partial products
	reg [N-1:0] stage1_sum;
	reg [N-1:0] stage2_sum;

	integer i;

	// Generate partial products
	always @(*) begin
		for (i = 0; i < size; i = i + 1) begin
			if (mul_b[i] == 1'b1) 
				partial_products[i] = {mul_a, {size{1'b0}}} << i; // Shift left by 'i' positions
			else
				partial_products[i] = {N{1'b0}}; // Zero partial product
		end
	end

	// First pipeline stage: Compute partial products sum
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			stage1_sum <= {N{1'b0}};
		end else begin
			// Add first half of partial products
			stage1_sum <= partial_products[0] + partial_products[1] +
						  partial_products[2] + partial_products[3];
		end
	end

	// Second pipeline stage: Compute final sum
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			stage2_sum <= {N{1'b0}};
		end else begin
			// Add second half of partial products on stage1_sum
			stage2_sum <= stage1_sum + partial_products[4] + partial_products[5] +
			              partial_products[6] + partial_products[7];
		end
	end

	// Output result
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			mul_out <= {N{1'b0}}; // Reset output
		else
			mul_out <= stage2_sum; // Assign final sum to output
	end
	
endmodule