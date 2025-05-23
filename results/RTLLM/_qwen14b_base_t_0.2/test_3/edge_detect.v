module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);
	
	// Internal register to store the previous value of 'a'
	reg prev_a;

	// On the positive edge of the clock, check for rising and falling edges
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Reset all outputs to 0
			rise <= 0;
			down <= 0;
			prev_a <= 0;
		end else begin
			// Store the current value of 'a' in prev_a for the next clock cycle
			prev_a <= a;
			
			// Check for rising edge
			if (prev_a == 0 && a == 1) begin
				rise <= 1;
				down <= 0;
			end
			
			// Check for falling edge
			else if (prev_a == 1 && a == 0) begin
				down <= 1;
				rise <= 0;
			end
			
			// If no edge is detected, set both signals to 0
			else begin
				rise <= 0;
				down <= 0;
			end
		end
	end
	
endmodule