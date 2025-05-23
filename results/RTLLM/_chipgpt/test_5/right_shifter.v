module registered_verilog_block (
	input clk,rst,out,in1,in2,in3,
	output reg out1,out2,out3
    );

	 reg out;
	 parameter[2:0] p=4; // 4-bit block
	 reg[p:0] q;
	 wire ena;
	 wire sum1,sum2,sum3;
	 wire[p-1:0] m1,m2,m3;

	 assign out1 = ena&out;
	 assign out2 = sum1;
	 assign out3 = sum3;

	 //registered block
	 always @(posedge clk) begin
	 if (rst) q <= 0; // 4-bit register must be initialized with zero when using the registered block
	 else if (~outa && ena) q <= m2; //use next-state logics for a state-hold circuit
	 else if (sum1==1 || sum3==1) q <= q+1;  //add 1 to next-state logic and use it as the next-state logic
	 else q <= q;  //otherwise, don't change the next-state logic
	 end

	 assign ena = out && ((in2==1 && (sum2==1 || sum3==1))||(in3==1));
	 assign sum1=(m1==1)?1:0;
	 assign sum2=(m2==1)?1:0;
	 assign sum3=(m3==1)?1:0;
	 
	 //state-hold circuit for output
	 always @(posedge clk) begin
	 out <= outa&out;
	 end
endmodule