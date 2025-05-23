module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);

	// Internal signal to store previous value of a
	reg prev_a;

	// Asynchronous reset
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			rise <= 1'b0;
			down <= 1'b0;
			prev_a <= 1'b0;
		end else begin
			// Detect rising edge
			if (a == 1'b1 && prev_a == 1'b0) begin
				rise <= 1'b1;
			end else begin
				rise <= 1'b0;
			end

			// Detect falling edge
			if (a == 1'b0 && prev_a == 1'b1) begin
				down <= 1'b1;
			end else begin
				down <= 1'b0;
			end

			// Update previous value of a
			prev_a <= a;
		end
	end

endmodule