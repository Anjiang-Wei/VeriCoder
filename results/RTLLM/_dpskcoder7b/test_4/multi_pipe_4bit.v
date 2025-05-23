module multi_pipe_4bit#(
	parameter size = 4
)(
	input 						clk 		,   
	input 						rst_n		,
	input	[size-1:0]			mul_a		,
	input	[size-1:0]			mul_b		,
 
 	output	reg	[2*size-1:0]	mul_out		
);

// Extend input signals
wire [2*size-1:0] mul_a_ext = {{(size){1'b0}}, mul_a};
wire [2*size-1:0] mul_b_ext = {{(size){1'b0}}, mul_b};

// Perform multiplication operation
genvar i;
generate
	for (i = 0; i < size; i = i + 1) begin : mul_gen
		assign mul_out[i+size] = mul_a_ext[i] ? mul_b_ext[i] : 1'b0;
	end
endgenerate

// Add partial products
reg [2*size-1:0] add_reg;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		add_reg <= 1'b0;
	end else begin
		add_reg <= mul_out;
	end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mul_out <= 1'b0;
	end else begin
		mul_out <= add_reg;
	end
end

endmodule