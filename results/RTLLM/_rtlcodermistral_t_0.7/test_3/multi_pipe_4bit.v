```verilog
reg [N-1:0] partial_products [0:size-1];
reg [size*2-1:0] sum;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		sum <= 0;
	end else begin
		sum <= 0;
		for (size_t i = 0; i < size; i = i + 1) begin
			if (mul_b[i] == 1) begin
				partial_products[i] <= {mul_a, {size-i{1'b0}}};
			end else begin
				partial_products[i] <= 0;
			end
			sum <= sum + partial_products[i];
		end
	end
end

assign mul_out = sum;

endmodule