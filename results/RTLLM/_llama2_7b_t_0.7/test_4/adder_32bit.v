module adder_32bit(A,B,S,C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    // Instantiate 16-bit CLA blocks
    localparam WIDTH = 16;
    CLA #($globals A.width-1) ADder_16bit(A, B, S16, C16);
    CLA #($globals B.width-1) ADder_16bit(B, S16, C16);
    assign S = ADder_16bit.S16;
    assign C32 = ADder_16bit.C16 & (A | B);
endmodule