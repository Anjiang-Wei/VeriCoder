module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);

	// Internal signal to store the previous state of 'a'
	reg a_prev;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Active-low reset: initialize all outputs and state
			rise <= 0;
			down <= 0;
			a_prev <= 0;
		end else begin
			// Detect rising edge: current 'a' is 1 and previous 'a' was 0
			rise <= (a && !a_prev);
			
			// Detect falling edge: current 'a' is 0 and previous 'a' was 1
			down <= (!a && a_prev);
			
			// Update the previous state of 'a'
			a_prev <= a;
		end
	end

endmodule