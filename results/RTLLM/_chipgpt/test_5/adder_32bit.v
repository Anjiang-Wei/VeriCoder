module carry_lookahead_adder(
	input [31:0] A,B,C,S,
	output [31:0] S_out,C_out
    );
	 
	wire [30:0] A_bar=A[2:0]; //1st mux has 4 inputs and selects the top input(0 or 1) to output
	wire [31:0] B_bar;
	assign B_bar = B[2:0];//2nd mux has 4 inputs and selects the bottom input (31 or 30) to output
	wire sum,C_next;
	 
	 wire C_bar=A_bar^B_bar; //first NAND gate
	 assign sum = A_bar+B_bar;//NOR gate
	assign C_next=C+sum; //NOR gate that outputs carry if the sum is even, or 0 otherwise.
	
	 
	 
	 
	 cla_16 m0(A[3:0],B[3:0],C,S_out,C_next); //mux selects between C and sum as input to next NOR gate.
	 cla_16 m1(A[7:4],B[7:4],C,S_out,C_next);
	 
	 
	 
endmodule