module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;
 
      wire sum[32:1]; //output of CLA block for next stage
      wire carry_out; //output of CLA block for next stage

       CLA16 m0(A[15:0],B[15:0],S[15:0],C32,sum[15:0]);// 16-bit CLA block

       CLA16 m1(A[31:16],B[31:16],S[31:16],carry_out,sum[31:16]); // 16-bit CLA block
 
endmodule