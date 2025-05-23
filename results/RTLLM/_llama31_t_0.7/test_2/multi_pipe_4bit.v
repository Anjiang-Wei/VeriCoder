module multi_pipe_4bit#(
	parameter size = 4
)(
	input 						clk 		,   // clock signal
	input 						rst_n		,  // active-low reset signal
	input	[size-1:0]			mul_a		,  // multiplicand (input)
	input	[size-1:0]			mul_b		,  // multiplier (input)

	output	reg	[2*size-1:0]	mul_out	// product output (output)
);

parameter N = 2 * size;

// Extended input signals
wire	[size-1:0]	ext_mul_a;  // extended multiplicand
wire	[size-1:0]	ext_mul_b;  // extended multiplier

assign ext_mul_a = {mul_a[size-1], mul_a[size-2:size]};
assign ext_mul_b = {mul_b[size-1], mul_b[size-2:size]};

// Partial product generation (no need to implement this as it's trivial)
wire	[size+size-1:0]	partial_products[size];

generate
	for(genvar i = 0; i < size; i++) begin
		assign partial_products[i][i+:size] = ext_mul_a * ((ext_mul_b >> i) & 1);
	end
endgenerate

// Register to hold intermediate sum
reg	[2*size-1:0]	sum_reg;

always @ (posedge clk or negedge rst_n)
	if (~rst_n)
		sum_reg <= 'd0;
	else
		sum_reg <= sum_reg + {partial_products[size-1][size-1+:size], 0};

// Final product calculation
reg	[2*size-1:0]	final_sum;

always @ (posedge clk or negedge rst_n)
	if (~rst_n)
		final_sum <= 'd0;
	else
		final_sum <= sum_reg;

// Output signal
assign mul_out = final_sum[size+:size];

endmodule