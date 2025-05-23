module adder_32bit(A, B, S, C32);
    // 32-bit adder using two 16-bit CLA blocks
    input  [32:1] A, B;
    output [32:1] S;
    output        C32;

    wire C16;

    // lower 16 bits
    cla16 lo (
        .A    (A[16:1]),
        .B    (B[16:1]),
        .Cin  (1'b0),
        .S    (S[16:1]),
        .Cout (C16)
    );

    // upper 16 bits
    cla16 hi (
        .A    (A[32:17]),
        .B    (B[32:17]),
        .Cin  (C16),
        .S    (S[32:17]),
        .Cout (C32)
    );
endmodule