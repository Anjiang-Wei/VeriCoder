always @(posedge clk)
	if (rst_n) rise <= 1'b0;
	else if (a && ~rising_edge(clk)) rise <= 1'b1; // if a is high and next clock tick has no rising edge, then the output should be '1'
	else rise <= 1'b0;
		
always @(posedge clk)
	if (rst_n) down <= 1'b0;
	else if (!a && falling_edge(clk)) down <= 1'b1; //if a is low and next clock tick has falling edge, then the output should be '1'
	else down <= 1'b0;

endmodule