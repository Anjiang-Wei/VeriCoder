module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     // Internal signals for carry lookahead
     wire [15:0] P1, G1;
     wire [15:0] P2, G2;
     wire [15:0] C1, C2;
     wire [15:0] C3;
     wire [15:0] C4;
     wire [15:0] C5;
     wire [15:0] C6;
     wire [15:0] C7;
     wire [15:0] C8;
     wire [15:0] C9;
     wire [15:0] C10;
     wire [15:0] C11;
     wire [15:0] C12;
     wire [15:0] C13;
     wire [15:0] C14;
     wire [15:0] C15;
     wire [15:0] C16;

     // Instantiate two 16-bit CLA blocks
     CLA_16bit CLA1 (A[16:1], B[16:1], S[16:1], C16, P1, G1);
     CLA_16bit CLA2 (A[32:17], B[32:17], S[32:17], C32, P2, G2);

     // Generate carry signals for the second CLA block
     assign C1 =  G1[0] | (P1[0] & C16);
     assign C2 =  G1[1] | (P1[1] & C1);
     assign C3 =  G1[2] | (P1[2] & C2);
     assign C4 =  G1[3] | (P1[3] & C3);
     assign C5 =  G1[4] | (P1[4] & C4);
     assign C6 =  G1[5] | (P1[5] & C5);
     assign C7 =  G1[6] | (P1[6] & C6);
     assign C8 =  G1[7] | (P1[7] & C7);
     assign C9 =  G1[8] | (P1[8] & C8);
     assign C10 = G1[9] | (P1[9] & C9);
     assign C11 = G1[10] | (P1[10] & C10);
     assign C12 = G1[11] | (P1[11] & C11);
     assign C13 = G1[12] | (P1[12] & C12);
     assign C14 = G1[13] | (P1[13] & C13);
     assign C15 = G1[14] | (P1[14] & C14);

     // Connect carry signals to the second CLA block
     assign C16 = G1[15] | (P1[15] & C15);
     assign C17 = G2[0] | (P2[0] & C16);
     assign C18 = G2[1] | (P2[1] & C17);
     assign C19 = G2[2] | (P2[2] & C18);
     assign C20 = G2[3] | (P2[3] & C19);
     assign C21 = G2[4] | (P2[4] & C20);
     assign C22 = G2[5] | (P2[5] & C21);
     assign C23 = G2[6] | (P2[6] & C22);
     assign C24 = G2[7] | (P2[7] & C23);
     assign C25 = G2[8] | (P2[8] & C24);
     assign C26 = G2[9] | (P2[9] & C25);
     assign C27 = G2[10] | (P2[10] & C26);
     assign C28 = G2[11] | (P2[11] & C27);
     assign C29 = G2[12] | (P2[12] & C28);
     assign C30 = G2[13] | (P2[13] & C29);
     assign C31 = G2[14] | (P2[14] & C30);

endmodule