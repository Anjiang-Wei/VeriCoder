module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);

reg prev_a;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rise <= 1'b0;
		down <= 1'b0;
		prev_a <= 1'b0;
	end else begin
		prev_a <= a;
		if (a && !prev_a) begin
			rise <= 1'b1;
			down <= 1'b0;
		end else if (!a && prev_a) begin
			rise <= 1'b0;
			down <= 1'b1;
		end else begin
			rise <= 1'b0;
			down <= 1'b0;
		end
	end
end

endmodule