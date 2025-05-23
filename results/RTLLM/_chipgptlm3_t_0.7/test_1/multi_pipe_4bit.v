reg [size-1:0] a_reg;
reg [size-1:0] b_reg;
reg [size-1:0] product_reg;
reg [N-1:0] sum_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		a_reg <= {size{1'b0}};
		b_reg <= {size{1'b0}};
		product_reg <= {size{1'b0}};
		sum_reg <= {N{1'b0}};
	end else begin
		a_reg <= mul_a;
		b_reg <= mul_b;
		for (i=0; i<size; i=i+1) begin
			if (b_reg[size-1-i] == 1'b1) begin
				product_reg <= product_reg + (a_reg << i);
			end
		end
		sum_reg <= sum_reg + product_reg;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		mul_out <= 0;
	end else begin
		mul_out <= sum_reg;
	end
end

endmodule