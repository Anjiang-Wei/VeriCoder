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

wire [N-1:0] a_ext, b_ext;
genvar i;

// Input signal extension
assign a_ext = {size{1'b0}}, b_ext = {size{1'b0}};

// Generate block for partial product calculation
generate
	for (i = 0; i < size; i = i + 1) begin : gen_partial_product
		assign mul_out[i] = b_ext[i] ? a_ext << i : 1'b0;
	end
endgenerate

reg [N-1:0] partial_sum, final_sum;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		partial_sum <= {N{1'b0}};
		final_sum <= {N{1'b0}};
	end else begin
		partial_sum <= partial_sum + mul_out;
		final_sum <= partial_sum;
	end
end

// Final product output
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= {N{1'b0}};
	end else begin
		mul_out <= final_sum;
	end
end

endmodule