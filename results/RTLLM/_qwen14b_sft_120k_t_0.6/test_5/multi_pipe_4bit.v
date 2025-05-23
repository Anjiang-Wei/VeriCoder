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

reg [N-1:0] partial_product [0:size-1];
reg [N-1:0] sum [0:size-1];

integer i;

// Extension of input signals
genvar j;
generate
	for (j = 0; j < size; j = j + 1) begin : gen_pp
		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				partial_product[j] <= {N{1'b0}};
			end else begin
				if (mul_b[j] == 1'b1) begin
					partial_product[j] <= {mul_a, {size{1'b0}}} << j;
				end else begin
					partial_product[j] <= {N{1'b0}};
				end
			end
		end
	end
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0; i < size; i = i + 1) begin
			sum[i] <= {N{1'b0}};
		end
	end else begin
		for (i = 0; i < size; i = i + 1) begin
			sum[i] <= sum[i] + partial_product[i];
		end
	end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= {N{1'b0}};
	end else begin
		mul_out <= sum[0] + sum[1] + sum[2] + sum[3];
	end
end

endmodule