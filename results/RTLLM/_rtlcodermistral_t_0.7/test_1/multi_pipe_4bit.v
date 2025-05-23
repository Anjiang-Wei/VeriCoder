```verilog
reg [size-1:0] partial_products [0:size-1];
reg [size*2-1:0] registers [0:size-1];

integer i;

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		for (i = 0; i < size; i = i + 1) begin
			partial_products[i] <= 0;
			registers[i] <= 0;
		end
		mul_out <= 0;
	end
	else begin
		for (i = 0; i < size; i = i + 1) begin
			partial_products[i] <= (mul_b[i] ? {mul_a, {size-i{1'b0}}} : 0);
			registers[i] <= (i == 0) ? partial_products[i] : (registers[i-1] + partial_products[i]);
		end
		mul_out <= (rst_n) ? (sum == 0) ? 0 : {sum[N-1:size], {size{1'b0}}} : 0;
	end
end

endmodule