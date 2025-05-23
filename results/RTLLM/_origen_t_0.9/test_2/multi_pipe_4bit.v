Please complete the Verilog code below and return the complete module code directly:
```verilog
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

wire	[size:0]	p[size:0];
reg	[N-1:0]		s[size:0];

// Input signal extension
assign	p[0] = {1'b0, mul_b};
assign	mul_a = {mul_a, {size{1'b0}}};

genvar i;
generate
	for (i = 0; i < size; i = i + 1) begin : gen_p
		assign	p[i+1]	= (p[i][0]) ? mul_a << i : 'd0;
	end
endgenerate

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (int j = 0; j <= size; j = j + 1) begin
			s[j] <= 'd0;
		end
	end
	else begin
		s[0] <= 'd0;
		for (int j = 1; j <= size; j = j + 1) begin
			s[j] <= s[j-1] + p[j];
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= 'd0;
	end
	else begin
		mul_out <= s[size];
	end
end

endmodule