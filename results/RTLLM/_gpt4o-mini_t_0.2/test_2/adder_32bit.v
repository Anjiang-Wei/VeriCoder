module adder_32bit(A, B, S, C32);
    input [31:0] A;   // Corrected index for Verilog (0-31)
    input [31:0] B;   // Corrected index for Verilog (0-31)
    output [31:0] S;  // Corrected index for Verilog (0-31)
    output C32;       // 32nd carry out

    wire C16_1;       // Carry out from first 16-bit CLA
    wire C16_2;       // Carry out from second 16-bit CLA

    // Instantiate first 16-bit CLA
    cla_16bit CLA1 (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),  // No carry in for the least significant bits
        .S(S[15:0]),
        .Cout(C16_1)
    );

    // Instantiate second 16-bit CLA
    cla_16bit CLA2 (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16_1), // Carry in from the first 16-bit CLA
        .S(S[31:16]),
        .Cout(C32)    // Carry out of the 32-bit adder
    );

endmodule

// 16-bit Carry Lookahead Adder Module
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [15:0] P; // propagate
    wire [15:0] G; // generate
    wire [3:0] C;  // carry bits

    // Generate and propagate
    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // Carry computation
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]); // Final Carry-out

    // Sum computation
    assign S = P ^ {C[0], C[0], C[1], C[1], C[2], C[2], C[3], C[3]};

endmodule