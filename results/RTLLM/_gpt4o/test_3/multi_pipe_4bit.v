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

// Internal signals for partial products and pipeline registers
reg [N-1:0] partial_products [0:size-1];  // Partial product array
reg [N-1:0] sum_stage1;                  // Intermediate sum: stage 1
reg [N-1:0] sum_stage2;                  // Intermediate sum: stage 2

integer i;

// Generate block to compute partial products
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// Reset all partial products
		for (i = 0; i < size; i = i + 1) begin
			partial_products[i] <= 0;
		end
	end else begin
		// Compute partial products based on the multiplier's bits
		for (i = 0; i < size; i = i + 1) begin
			if (mul_b[i]) begin
				partial_products[i] <= {mul_a, {(i){1'b0}}};  // Left-shift mul_a by i
			end else begin
				partial_products[i] <= {N{1'b0}};  // Else set to 0
			end
		end
	end
end

// Stage 1: Add partial products [0] and [1]
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		sum_stage1 <= 0;  // Reset intermediate sum
	end else begin
		sum_stage1 <= partial_products[0] + partial_products[1];
	end
end

// Stage 2: Add partial products from higher bits [2, 3] and combine with stage1
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		sum_stage2 <= 0;  // Reset intermediate sum
	end else begin
		sum_stage2 <= partial_products[2] + partial_products[3] + sum_stage1;
	end
end

// Final output calculation
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= 0;  // Reset final output
	end else begin
		mul_out <= sum_stage2;  // Assign the result
	end
end

endmodule