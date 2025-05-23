module edge_detect(
	input clk,
	input rst_n,
	input a,
	output reg rise,
	output reg down
);

reg a_delay;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		a_delay <= 1'b0;
		rise <= 1'b0;
		down <= 1'b0;
	end
	else begin
		a_delay <= a;
		if (a & ~a_delay) begin
			rise <= 1'b1;
			down <= 1'b0;
		end
		else if (~a & a_delay) begin
			rise <= 1'b0;
			down <= 1'b1;
		end
		else begin
			rise <= 1'b0;
			down <= 1'b0;
		end
	end
end

endmodule