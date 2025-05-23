module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);

	reg a_d1;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			a_d1 <= 0;
			rise <= 0;
			down <= 0;
		end
		else begin
			a_d1 <= a;
			if (a_d1 && ~a) begin
				rise <= 1;
				down <= 0;
			end
			else if (~a_d1 && a) begin
				rise <= 0;
				down <= 1;
			end
			else begin
				rise <= 0;
				down <= 0;
			end
		end
	end

endmodule