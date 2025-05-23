```verilog
reg	[size-1:0]	partial_products [0:size-1];
reg	[N-1:0]		registers [0:size-1];
reg	[N-1:0]		sum;

always @(posedge clk, negedge rst_n) begin
	if (~rst_n) begin
		for (int i = 0; i < size; i = i + 1) begin
			partial_products[i] <= 0;
			registers[i] <= 0;
		end
		sum <= 0;
	end
	else begin
		for (int i = 0; i < size; i = i + 1) begin
			if (mul_b[i] == 1) begin
				partial_products[i] <= {mul_a, {size-i{1'b0}}};
			end
			else begin
				partial_products[i] <= 0;
			end
		end
		for (int i = 0; i < size; i = i + 1) begin
			registers[i] <= sum;
			sum <= 0;
			for (int j = 0; j < size; j = j + 1) begin
				if (i + j < size) begin
					sum <= sum + partial_products[j][i + j];
				end
			end
		end
	end
end

assign mul_out = sum;

endmodule