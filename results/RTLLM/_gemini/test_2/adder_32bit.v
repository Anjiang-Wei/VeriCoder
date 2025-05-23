module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     // Internal signals for carry lookahead
     wire [15:0] P1, G1, P2, G2;
     wire [15:0] C1, C2;
     wire [31:0] carry;

     // Instantiate two 16-bit CLA blocks
     cla_16bit CLA1 (A[16:1], B[16:1], S[16:1], C1, P1, G1);
     cla_16bit CLA2 (A[32:17], B[32:17], S[32:17], C2, P2, G2);

     // Generate carry-in for the second CLA block
     assign carry[16] = C1[15];

     // Generate carry signals for the second CLA block
     generate
         genvar i;
         for (i = 17; i <= 31; i = i + 1) begin : carry_gen
             assign carry[i] = (G2[i-17] | (P2[i-17] & carry[i-1]));
         end
     endgenerate

     // Assign carry-out
     assign C32 = carry[31];

     // Instantiate two 4-bit adders for the first 8 bits
     assign S[8:1] = A[8:1] ^ B[8:1] ^ carry[8];
     assign S[7:1] = A[7:1] ^ B[7:1] ^ carry[7];
     assign S[6:1] = A[6:1] ^ B[6:1] ^ carry[6];
     assign S[5:1] = A[5:1] ^ B[5:1] ^ carry[5];
     assign S[4:1] = A[4:1] ^ B[4:1] ^ carry[4];
     assign S[3:1] = A[3:1] ^ B[3:1] ^ carry[3];
     assign S[2:1] = A[2:1] ^ B[2:1] ^ carry[2];
     assign S[1] = A[1] ^ B[1] ^ carry[1];

endmodule