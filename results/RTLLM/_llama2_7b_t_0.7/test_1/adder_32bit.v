module adder_32bit(A,B,S,C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    // Instantiate the 16-bit CLA block
    CLA_16bit u_cla16(A,B,S[15],C32);

    // Instantiate the 16-bit CLA block for the carry output
    CLA_16bit u_cla16_carry(B[15],C32);

    // Connect the inputs and outputs of the 16-bit CLAs
    S = S[15] + B[15];
    C32 = u_cla16.out & u_cla16_carry.out;