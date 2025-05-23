module adder_32bit(A,B,S,C32);
    input [32:1] A; // 32-bit input operand A
    input [32:1] B; // 32-bit input operand B
    output [32:1] S; // 32-bit output representing the sum of A and B
    output C32; // Carry-out output

    // Top module instance of 16-bit CLA block
    CLA16 u_cla(A, B, S[15], C32); // Top CLA instance

    // Instantiate multiple instances of the 16-bit CLA block
    CLA16 u_cla0(A, B, S[15], C32); // Second CLA instance
    CLA16 u_cla1(A, B, S[15], C32); // Third CLA instance

    // Connect the output of each 16-bit CLA block to the input of the next one
    S = S[15] + S[14:0]; // Connect the output of each CLA block to the input of the next one
    C32 = C32 + C32[15:0]; // Connect the carry-out of each CLA block to the input of the next one

endmodule