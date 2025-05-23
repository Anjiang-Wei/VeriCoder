module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

	wire[15:0] S16;  // 4-bit result of the 16-bit CLA block.
	wire[15:0] S24;  // 8-bit result of the 24-bit CLA block.
	wire S32;       // 32-bit sum of A and B
	//C32 output from the 32-bit adder is used as a carry for the next 16-bit CLA module
	assign C32 = (A[31]&B[31]) | (S32);

	 // 16 bit block that can be cascaded to design an 8-bit adder and finally a 4-bit adder, as per the Carry-Lookahead Adder(CLA) architecture.
     CLA #(.W(16), .H(16)) m0(A[15:0],B[15:0],S16,C32); // output S[15:0] and C32
     CLA #(.W(24), .H(24)) m1(S16,B[31:16],S24,C32);    // output S[31:0] and C32
	//outputing the 32-bit sum of A and B directly
     assign S[31:0] = S24;
endmodule