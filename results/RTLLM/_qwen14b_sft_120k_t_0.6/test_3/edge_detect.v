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
		prev_a <= 1'b0;
		rise <= 1'b0;
		down <= 1'b0;
	end else begin
		prev_a <= a; // Store previous value of a
		if (prev_a == 1'b0 && a == 1'b1) begin
			rise <= 1'b1; // Rising edge detected
			down <= 1'b0;
		end else if (prev_a == 1'b1 && a == 1'b0) begin
			down <= 1'b1; // Falling edge detected
			rise <= 1'b0;
		end else begin
			rise <= 1'b0;
			down <= 1'b0; // No edge detected
		end
	end
end

endmodule