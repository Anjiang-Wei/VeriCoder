module freq_div (
	input clk,rst_n,
	output reg clk2x,clk4x,
	// output regs
	output reg clk50m,clk10m,clk1m
    );
	 // 100M/2=50M
	 always @(posedge clk or posedge rst_n) begin
		if(!rst_n) clk2x <= 0; // reset to 0 at start of every cycle
		else if(clk2x) clk4x = ~clk4x; // toggle the 16-bit counter if it is already high or low
		else clk2x = 1'b1;
	 end
	 
	 always @* begin
		clk50m = 1'b0;
		clk10m = 1'b0;
		clk1m = 1'b0;
		if(!rst_n) begin // start with all regs at 0
			clk4x <= 0; // reset the counter to zero
		end
		else if(~clk4x) clk50m = ~clk50m;
		else if((~clk4x == 1'b0 && clk4x == 1'b1)) clk10m = ~clk10m; //if the counter wraps around to zero, it will flip again and toggle its output
		else clk50m = ~clk50m;
		clk1m = (~clk4x == 1'b0 && clk10m == 1'b1) ? ~clk1m : ~clk1m; //if the counter wraps around to zero, it will flip again and toggle its output
	 end

endmodule