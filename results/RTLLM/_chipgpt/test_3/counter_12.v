module top_module
(
	input clk,
	input rst_n,
	input valid_count,
	output reg [3:0] out	//register
);
	 counter_12 m0 (rst_n,clk,valid_count,out); 
endmodule