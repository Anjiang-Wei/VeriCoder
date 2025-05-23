module edge_detect(
	input clk,
	input rst_n,
	input a,
	
	output reg rise,
	output reg down
);

// Internal registers to store the current and previous states of input signal a
reg a_current;
reg a_previous;

// At every positive edge of the clock, update the current and previous states of input signal a
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		a_current <= 0;
		a_previous <= 0;
		rise <= 0;
		down <= 0;
	end else begin
		a_previous <= a_current;
		a_current <= a;
		
		// Check for rising edge
		if (a_previous == 0 && a_current == 1) begin
			rise <= 1;
		end else begin
			rise <= 0;
		end
		
		// Check for falling edge
		if (a_previous == 1 && a_current == 0) begin
			down <= 1;
		end else begin
			down <= 0;
		end
	end
end

endmodule