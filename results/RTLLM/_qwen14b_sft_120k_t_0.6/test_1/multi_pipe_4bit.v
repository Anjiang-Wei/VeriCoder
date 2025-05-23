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

reg [N-1:0] partial_products [0:size-1];
reg [N-1:0] sum [0:size-1];

// Extension of input signals
wire [N-1:0] mul_a_ext = {size{1'b0}, mul_a};
wire [N-1:0] mul_b_ext = {size{1'b0}, mul_b};

generate
	genvar i;
	for (i = 0; i < size; i = i + 1) begin : gen_partial_products
		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) 
				partial_products[i] <= {N{1'b0}};
			else 
				partial_products[i] <= (mul_b_ext[i] == 1'b1) ? {mul_a_ext, {size-1-i{1'b0}}} : {N{1'b0}};
		end
	end
endgenerate

// Sum of partial products
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (int j = 0; j < size; j = j + 1) begin
			sum[j] <= {N{1'b0}};
		end
	end else begin
		sum[0] <= partial_products[0];
		for (int j = 1; j < size; j = j + 1) begin
			sum[j] <= sum[j-1] + partial_products[j];
		end
	end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
		mul_out <= {N{1'b0}};
	else 
		mul_out <= sum[size-1];
end

endmodule