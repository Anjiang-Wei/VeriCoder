module adder_32bit(A, B, S, C32);
    input [31:0] A; // Changed 32:1 to 31:0 for correct indexing in Verilog
    input [31:0] B;
    output [31:0] S;
    output C32;

    wire [15:0] P0, G0; // Generate and propagate for lower 16 bits
    wire [15:0] P1, G1; // Generate and propagate for upper 16 bits
    wire C16; // Carry-out from the lower 16-bit CLA

    // Instantiate 16-bit CLA blocks
    cla_16bit CLA0 (
        .A(A[15:0]),
        .B(B[15:0]),
        .S(S[15:0]),
        .C_out(C16), // Carry-out from the lower 16-bit CLA
        .P(P0),
        .G(G0)
    );

    cla_16bit CLA1 (
        .A(A[31:16]),
        .B(B[31:16]),
        .S(S[31:16]),
        .C_out(C32), // Carry-out for the entire 32-bit sum
        .P(P1),
        .G(G1)
    );

    // Carry generation for the upper 16-bit CLA
    assign C32 = G1[0] | (P1[0] & C16); // C_out for the second CLA

endmodule

module cla_16bit(A, B, S, C_out, P, G);
    input [15:0] A;
    input [15:0] B;
    output [15:0] S;
    output C_out;
    output [15:0] P;
    output [15:0] G;

    wire [3:0] C; // Internal carries
    wire [15:0] P_local, G_local; // Local propagate and generate

    // Generate and propagate for each bit in CLA
    assign P_local = A ^ B; // Propagate
    assign G_local = A & B; // Generate

    assign P = P_local;
    assign G = G_local;

    // Carry lookahead logic
    assign C[0] = G_local[0];
    assign C[1] = G_local[1] | (P_local[1] & G_local[0]);
    assign C[2] = G_local[2] | (P_local[2] & G_local[1]) | (P_local[2] & P_local[1] & G_local[0]);
    assign C[3] = G_local[3] | (P_local[3] & G_local[2]) | (P_local[3] & P_local[2] & G_local[1]) | (P_local[3] & P_local[2] & P_local[1] & G_local[0]);

    // Output carry
    assign C_out = C[3];

    // Sum generation
    assign S = P_local ^ {C[0], C[0], C[1], C[1], C[2], C[2], C[3], C[3]}; // Summation logic based on propagate and carry

endmodule