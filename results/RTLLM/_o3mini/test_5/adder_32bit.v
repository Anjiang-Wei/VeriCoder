module adder_32bit(A, B, S, C32);
    input  [32:1] A;
    input  [32:1] B;
    output [32:1] S;
    output        C32;

    wire c16;  // Carry-out from lower 16-bit block becomes carry-in to upper 16-bit block

    // Lower 16-bit adder: bits 1 to 16.
    cla_16bit lower16 (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),  // Assuming no external carry in for the full adder
        .S(S[16:1]),
        .Cout(c16)
    );
    
    // Upper 16-bit adder: bits 17 to 32.
    cla_16bit upper16 (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(c16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule