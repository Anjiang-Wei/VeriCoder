reg	[N-1:0] 	add_result;

// Extend input signals
wire	[N-1:0]	mul_a_ext = {{(size){1'b0}}, mul_a};
wire	[N-1:0]	mul_b_ext = {{(size){1'b0}}, mul_b};

// Multiplication operation
generate
genvar i;
for(i=0; i<size; i=i+1)
begin: gen_mul
	assign mul_out[i] = mul_a_ext[i] ? mul_b_ext[i] : 1'b0;
end
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n)
begin
	if(~rst_n) begin
		add_result <= 1'b0;
	end
	else begin
		add_result <= mul_out;
	end
end

// Final product calculation
always @(posedge clk or negedge rst_n)
begin
	if(~rst_n) begin
		mul_out <= 1'b0;
	end
	else begin
		mul_out <= add_result;
	end
end

endmodule