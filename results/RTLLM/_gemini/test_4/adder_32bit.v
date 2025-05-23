module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     // Internal signals for carry lookahead
     wire [15:0] P1, G1;
     wire [15:0] P2, G2;
     wire [15:0] C1, C2;
     wire [15:0] C_in1, C_in2;

     // Instantiate two 16-bit CLA blocks
     cla_16bit CLA1 (A[16:1], B[16:1], S[16:1], C1, P1, G1, C_in1);
     cla_16bit CLA2 (A[32:17], B[32:17], S[32:17], C2, P2, G2, C_in2);

     // Generate carry-in for the second CLA block
     assign C_in2 = C1[15];

     // Generate final carry-out
     assign C32 = C2[15];

endmodule