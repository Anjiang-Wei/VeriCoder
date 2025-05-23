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

reg [N-1:0] mul_a_reg, mul_b_reg, partial_products_reg, sum_reg, final_sum_reg;
integer i;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 0) begin
		mul_a_reg <= 0;
		mul_b_reg <= 0;
		partial_products_reg <= 0;
		sum_reg <= 0;
		final_sum_reg <= 0;
	end else begin
		mul_a_reg <= mul_a;
		mul_b_reg <= mul_b;
		partial_products_reg <= 0;
		sum_reg <= 0;
		final_sum_reg <= 0;
		for (i = 0; i < size; i = i + 1) begin
			if (mul_b_reg[i] == 1) begin
				partial_products_reg[i] <= mul_a_reg << i;
			end else begin
				partial_products_reg[i] <= 0;
			end
		end
		sum_reg <= sum_reg + partial_products_reg;
		final_sum_reg <= final_sum_reg + sum_reg;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 0) begin
		mul_out <= 0;
	end else begin
		mul_out <= final_sum_reg;
	end
end

endmodule