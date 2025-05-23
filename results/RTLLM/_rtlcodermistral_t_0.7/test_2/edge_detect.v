module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);

reg prev_a;

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		rise <= 0;
		down <= 0;
		prev_a <= 0;
	end
	else begin
		if (a && ~prev_a) begin
			rise <= 1;
			down <= 0;
		end
		else if (~a && prev_a) begin
			rise <= 0;
			down <= 1;
		end
		else begin
			rise <= 0;
			down <= 0;
		end
		prev_a <= a;
	end
end

endmodule