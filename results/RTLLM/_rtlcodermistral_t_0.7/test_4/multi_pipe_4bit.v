```verilog
reg [size-1:0] p_product [0:size-1];
reg [N-1:0] final_product;

integer i;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		final_product <= 0;
		for (i = 0; i < size; i = i + 1) begin
			p_product[i] <= 0;
		end
	end
	else begin
		for (i = 0; i < size; i = i + 1) begin
			if (mul_b[i] == 1) begin
				p_product[i] <= mul_a << i;
			end
			else begin
				p_product[i] <= 0;
			end
		end
		
		final_product <= 0;
		for (i = 0; i < size; i = i + 1) begin
			final_product <= final_product + p_product[i];
		end
	end
end

assign mul_out = final_product;

endmodule