module adder_32bit(A, B, S, C32);
    input [31:0] A;  // Corrected input width to 32 bits
    input [31:0] B;  // Corrected input width to 32 bits
    output [31:0] S; // Corrected output width to 32 bits
    output C32;

    // Internal signals for 16-bit CLA blocks
    wire [15:0] C16, G16, P16;
    wire [31:0] S16;
    wire C16_out;

    // 16-bit CLA blocks
    cla_16bit cla16_0 (A[15:0], B[15:0], S[15:0], C16[0], G16[0], P16[0], C16_out);
    cla_16bit cla16_1 (A[31:16], B[31:16], S[16:31], C16[1], G16[1], P16[1], C32);

    // 16-bit CLA block module
    module cla_16bit(A, B, S, C_out, G, P, C_in);
        input [15:0] A;
        input [15:0] B;
        output [15:0] S;
        output C_out;
        output [15:0] G;
        output [15:0] P;
        input C_in;

        // Generate and propagate signals
        assign G = A & B;
        assign P = A ^ B;

        // Generate carry-out
        assign C_out = G[15] | (P[15] & C_in);
        assign S = P ^ {16{C_in}}; // Propagate carry-in to all bits

        // Generate and propagate lookahead signals
        assign G[14] = G[14] | (G[15] & P[14]);
        assign P[14] = P[14] & P[15];
        assign G[13] = G[13] | (G[14] & P[13]);
        assign P[13] = P[13] & P[14];
        assign G[12] = G[12] | (G[13] & P[12]);
        assign P[12] = P[12] & P[13];
        assign G[11] = G[11] | (G[12] & P[11]);
        assign P[11] = P[11] & P[12];
        assign G[10] = G[10] | (G[11] & P[10]);
        assign P[10] = P[10] & P[11];
        assign G[9] = G[9] | (G[10] & P[9]);
        assign P[9] = P[9] & P[10];
        assign G[8] = G[8] | (G[9] & P[8]);
        assign P[8] = P[8] & P[9];
        assign G[7] = G[7] | (G[8] & P[7]);
        assign P[7] = P[7] & P[8];
        assign G[6] = G[6] | (G[7] & P[6]);
        assign P[6] = P[6] & P[7];
        assign G[5] = G[5] | (G[6] & P[5]);
        assign P[5] = P[5] & P[6];
        assign G[4] = G[4] | (G[5] & P[4]);
        assign P[4] = P[4] & P[5];
        assign G[3] = G[3] | (G[4] & P[3]);
        assign P[3] = P[3] & P[4];
        assign G[2] = G[2] | (G[3] & P[2]);
        assign P[2] = P[2] & P[3];
        assign G[1] = G[1] | (G[2] & P[1]);
        assign P[1] = P[1] & P[2];
        assign G[0] = G[0] | (G[1] & P[0]);
        assign P[0] = P[0] & P[1];

        // Final sum calculation
        assign S = P ^ {16{C_in}};
    endmodule
endmodule