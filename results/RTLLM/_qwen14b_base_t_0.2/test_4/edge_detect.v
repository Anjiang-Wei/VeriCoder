module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);
	
	// Internal register to store the previous value of 'a'
	reg prev_a;
	
	// Edge detection logic
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Reset all signals to 0
			rise <= 0;
			down <= 0;
			prev_a <= 0;
		end else begin
			// Detect rising and falling edges
			if (prev_a == 0 && a == 1) begin
				// Rising edge detected
				rise <= 1;
				down <= 0;
			end else if (prev_a == 1 && a == 0) begin
				// Falling edge detected
				down <= 1;
				rise <= 0;
			end else begin
				// No edge detected
				rise <= 0;
				down <= 0;
			end
			
			// Update the previous value of 'a'
			prev_a <= a;
		end
	end
	
endmodule