module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     wire [16:1] C;
     wire [16:1] P;
     wire [16:1] G;
     wire [16:1] C_out;

     CLA_16bit cla1(A[16:1],B[16:1],1'b0,S[16:1],P[16:1],G[16:1]);
     CLA_16bit cla2(A[32:16],B[32:16],C[16],S[32:16],P[16],G[16]);

     assign C32 = C_out[16];

endmodule