module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     // Internal signals for carry lookahead
     wire [15:0] P1, G1, P2, G2;
     wire [15:0] C1, C2;
     wire [31:0] C;

     // Instantiate two 16-bit CLA blocks
     cla_16bit CLA1 (A[16:1], B[16:1], S[16:1], C1[15:0], P1[15:0], G1[15:0]);
     cla_16bit CLA2 (A[32:17], B[32:17], S[32:17], C2[15:0], P2[15:0], G2[15:0]);

     // Generate carry-in for the second CLA block
     assign C1[0] = 0; // Initial carry-in for the first CLA block
     assign C2[0] = (G1[15] | (P1[15] & C1[15])); // Carry-out from the first CLA block

     // Generate carry signals for the 32-bit adder
     assign C[0] = C1[0];
     assign C[16] = C2[0];
     assign C[17] = (G2[0] | (P2[0] & C2[0]));
     assign C[18] = (G2[1] | (P2[1] & C2[1]));
     assign C[19] = (G2[2] | (P2[2] & C2[2]));
     assign C[20] = (G2[3] | (P2[3] & C2[3]));
     assign C[21] = (G2[4] | (P2[4] & C2[4]));
     assign C[22] = (G2[5] | (P2[5] & C2[5]));
     assign C[23] = (G2[6] | (P2[6] & C2[6]));
     assign C[24] = (G2[7] | (P2[7] & C2[7]));
     assign C[25] = (G2[8] | (P2[8] & C2[8]));
     assign C[26] = (G2[9] | (P2[9] & C2[9]));
     assign C[27] = (G2[10] | (P2[10] & C2[10]));
     assign C[28] = (G2[11] | (P2[11] & C2[11]));
     assign C[29] = (G2[12] | (P2[12] & C2[12]));
     assign C[30] = (G2[13] | (P2[13] & C2[13]));
     assign C[31] = (G2[14] | (P2[14] & C2[14]));
     assign C32 = (G2[15] | (P2[15] & C2[15]));

     // Generate sum bits
     assign S[1] = A[1] ^ B[1] ^ C[0];
     assign S[2] = A[2] ^ B[2] ^ C[1];
     assign S[3] = A[3] ^ B[3] ^ C[2];
     assign S[4] = A[4] ^ B[4] ^ C[3];
     assign S[5] = A[5] ^ B[5] ^ C[4];
     assign S[6] = A[6] ^ B[6] ^ C[5];
     assign S[7] = A[7] ^ B[7] ^ C[6];
     assign S[8] = A[8] ^ B[8] ^ C[7];
     assign S[9] = A[9] ^ B[9] ^ C[8];
     assign S[10] = A[10] ^ B[10] ^ C[9];
     assign S[11] = A[11] ^ B[11] ^ C[10];
     assign S[12] = A[12] ^ B[12] ^ C[11];
     assign S[13] = A[13] ^ B[13] ^ C[12];
     assign S[14] = A[14] ^ B[14] ^ C[13];
     assign S[15] = A[15] ^ B[15] ^ C[14];
     assign S[16] = A[16] ^ B[16] ^ C[15];
     assign S[17] = A[17] ^ B[17] ^ C[16];
     assign S[18] = A[18] ^ B[18] ^ C[17];
     assign S[19] = A[19] ^ B[19] ^ C[18];
     assign S[20] = A[20] ^ B[20] ^ C[19];
     assign S[21] = A[21] ^ B[21] ^ C[20];
     assign S[22] = A[22] ^ B[22] ^ C[21];
     assign S[23] = A[23] ^ B[23] ^ C[22];
     assign S[24] = A[24] ^ B[24] ^ C[23];
     assign S[25] = A[25] ^ B[25] ^ C[24];
     assign S[26] = A[26] ^ B[26] ^ C[25];
     assign S[27] = A[27] ^ B[27] ^ C[26];
     assign S[28] = A[28] ^ B[28] ^ C[27];
     assign S[29] = A[29] ^ B[29] ^ C[28];
     assign S[30] = A[30] ^ B[30] ^ C[29];
     assign S[31] = A[31] ^ B[31] ^ C[30];
     assign S[32] = A[32] ^ B[32] ^ C[31];

endmodule