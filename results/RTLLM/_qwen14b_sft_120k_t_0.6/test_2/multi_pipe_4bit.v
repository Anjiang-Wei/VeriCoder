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

// Extend input signals
wire [N-1:0] mul_a_ext = {size{1'b0}, mul_a};
wire [N-1:0] mul_b_ext = {size{1'b0}, mul_b};

reg [N-1:0] partial_product [0:size-1];
reg [N-1:0] sum;
reg [N-1:0] sum_1;

// Generate partial products
genvar i;
generate
	for (i = 0; i < size; i = i + 1) begin : gen_partial_product
		assign partial_product[i] = mul_a_ext << i;
	end
endgenerate

// Perform addition of partial products
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		sum_1 <= {N{1'b0}};
		sum <= {N{1'b0}};
	end else begin
		sum_1 <= partial_product[0];
		for (i = 1; i < size; i = i + 1) begin
			sum <= sum + partial_product[i];
		end
	end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= {N{1'b0}};
	end else begin
		mul_out <= sum_1 + sum;
	end
end

endmodule