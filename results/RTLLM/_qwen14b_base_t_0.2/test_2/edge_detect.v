module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);
	
	// Internal register to hold the previous value of 'a'
	reg a_prev;

	// Detect rising and falling edges
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			a_prev <= 0;
			rise <= 0;
			down <= 0;
		end else begin
			// Update the previous value of 'a'
			a_prev <= a;
			
			// Detect rising edge
			if (a_prev == 0 && a == 1) begin
				rise <= 1;
			end else begin
				rise <= 0;
			end
			
			// Detect falling edge
			if (a_prev == 1 && a == 0) begin
				down <= 1;
			end else begin
				down <= 0;
			end
		end
	end
	
endmodule