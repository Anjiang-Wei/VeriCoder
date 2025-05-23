```verilog
reg [size-1:0] partial_products [0:size-1];
reg [size*2-1:0] sum;

always @(posedge clk, negedge rst_n) begin
	if (~rst_n) begin
		sum <= 0;
	end else begin
		for (integer i = 0; i < size; i = i + 1) begin
			if (mul_b[i] == 1) begin
				partial_products[i] <= {mul_a, {size-i{1'b0}}};
			end else begin
				partial_products[i] <= 0;
			end
		end

		sum <= {partial_products[size-1], partial_products[size-2], partial_products[size-3], partial_products[size-4]} +
			  {partial_products[size-2], partial_products[size-3], partial_products[size-4], partial_products[size-5]} +
			  {partial_products[size-3], partial_products[size-4], partial_products[size-5], partial_products[size-6]} +
			  {partial_products[size-4], partial_products[size-5], partial_products[size-6], partial_products[size-7]} +
			  {partial_products[size-5], partial_products[size-6], partial_products[size-7], partial_products[size-8]};
	end
end

assign mul_out = sum;

endmodule