module adder_32bit(A, B, S, C32);
    input [31:0] A;  // Adjust the size to standard verilog range
    input [31:0] B;  // Adjust the size to standard verilog range
    output [31:0] S; // Adjust the size to standard verilog range
    output C32;

    wire C1; // Carry out from the first 16-bit CLA

    // Instantiate first 16-bit CLA
    cla_16bit cla1 (
        .A(A[15:0]),
        .B(B[15:0]),
        .C_in(1'b0), // No carry input for the least significant add
        .S(S[15:0]),
        .C_out(C1)
    );

    // Instantiate second 16-bit CLA
    cla_16bit cla2 (
        .A(A[31:16]),
        .B(B[31:16]),
        .C_in(C1), // Carry out from the first CLA becomes the input for the second
        .S(S[31:16]),
        .C_out(C32)
    );

endmodule