module multi_pipe_4bit#(
	parameter size = 4
)(
	input 					 clk,   
	input 					 rst_n,
	input	[size-1:0]		 mul_a,   
	input	[size-1:0]		 mul_b,

	output reg [size*2-1:0]	mul_out	
);

parameter N = 2 * size;

// Shift the multiplicand to align with current partial product
reg signed [N-1:0] shifted_a;
reg signed [N-1:0] sum_reg_1; // Store intermediate sum values in registers

always @(posedge clk or negedge rst_n) begin
	if (~rst_n)
		sum_reg_1 <= 'd0;
	else
		sum_reg_1 <= sum_reg_1 + shifted_a;
end

generate
	for (genvar i = 0; i < size; i++) begin : generate_block
		assign shifted_a[i] = mul_a ? {size-1-i{mul_a[i]}} : 'bz;
	end
endgenerate

// Final product calculation
always @(posedge clk or negedge rst_n) begin
	if (~rst_n)
		mul_out <= 'd0;
	else
		mul_out <= sum_reg_1;
end

endmodule