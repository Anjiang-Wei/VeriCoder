module top();
    parameter N=5;
	input clk;
	input[N-1:0] a;
	output reg[N-1:0] b;
	reg[N-1:0] dout;
	reg rise,down;
	edge_detect edg();  //declare the module directly here
	initial begin
		b=0;
	end
	always @(posedge clk) begin   //for every rising or falling edge of a, do this...
		if(!rise && !down) b <= dout+1'b1;//do 3-state binary up-down counter
		else if (rise && down) b <= dout-1'b1; //when the counter is at "max"(0 in case of 4-bit), do 3-state binary up-down counter
		else if(!rise && rise) b <= dout+1'b1;//do 3-state binary up-counter
		else if (down && !down) b <= dout-1'b1; //do 3-state binary down-counter
		dout<=b[N-2:0];
	end
	genvar i;
	always @(posedge clk) begin
		if(!rst_n) begin
			for (i=0;i<N;i=i+1) b[i] <= 0;
			dout <= 0;
		end
		else if(a && !risen && down==0) b[i]<=1'b1; //when an edge appears, next tick will be the max value (0 for case of 4-bit)
		else if(!a && risen && down == 0) b[i] <= 1'b0;   //when an edge does not appear, next tick will be the min value (3 in case of 4-bit)
	end
endmodule