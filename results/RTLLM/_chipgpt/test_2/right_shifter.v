module verified_right_shifter(
	input clk,
	input d,
	output [7:0] q  // Must be output!
    );

	 reg [7:0] q;

	 always @(posedge clk) begin
		q <= (q >> 1);
		q[7] <= d;
	 end

	 assign q = {~{q[6:0]},q[7]};
endmodule