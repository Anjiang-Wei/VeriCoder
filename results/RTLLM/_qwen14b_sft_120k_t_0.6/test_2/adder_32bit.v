module adder_32bit(A, B, S, C32);
    input [31:0] A;  // Input operand A
    input [31:0] B;  // Input operand B
    output [31:0] S; // Sum output
    output C32;      // Carry-out output

    wire C16, G16;  // Intermediate carry and generate signals
    wire [15:0] P16, G16_15; // Propagate and generate signals for 16-bit CLA

    // Instantiate 16-bit CLA blocks
    cla_16bits cla_16_0 (A[15:0], B[15:0], S[15:0], C16, P16[15:0], G16_15[15:0]);
    cla_16bits cla_16_1 (A[31:16], B[31:16], S[31:16], C32, P16[15:0], G16_15[15:0]);

    // Generate the carry-out (C32) using the carry-lookahead logic
    assign C32 = C16 | (P16[15] & G16);
    assign G16 = G16_15[15] | (P16[14] & G16_15[14]) | (P16[13] & G16_15[13]) | (P16[12] & G16_15[12]) | (P16[11] & G16_15[11]) | (P16[10] & G16_15[10]) | (P16[9] & G16_15[9]) | (P16[8] & G16_15[8]) | (P16[7] & G16_15[7]) | (P16[6] & G16_15[6]) | (P16[5] & G16_15[5]) | (P16[4] & G16_15[4]) | (P16[3] & G16_15[3]) | (P16[2] & G16_15[2]) | (P16[1] & G16_15[1]) | (P16[0] & G16_15[0]);
endmodule

module cla_16bits(A, B, S, C16, P, G);
    input [15:0] A; // Input operand A
    input [15:0] B; // Input operand B
    output [15:0] S; // Sum output
    output C16;      // Carry-out output
    output [15:0] P; // Propagate signals
    output [15:0] G; // Generate signals

    // Generate propagate and generate signals
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_propagate_generate
            assign P[i] = A[i] ^ B[i]; // Propagate signal
            assign G[i] = A[i] & B[i]; // Generate signal
        end
    endgenerate

    // Generate the sum and carry-out using the propagate and generate signals
    assign C16 = G[15] | (P[15] & G[14]) | (P[15] & P[14] & G[13]) | (P[15] & P[14] & P[13] & G[12]) | (P[15] & P[14] & P[13] & P[12] & G[11]) | (P[15] & P[14] & P[13] & P[12] & P[11] & G[10]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & G[9]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & G[8]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & G[7]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & G[6]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & G[5]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & G[4]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
    assign S[15] = A[15] ^ B[15] ^ C16; // Sum bit 15
    genvar j;
    generate
        for (j = 0; j < 15; j = j + 1) begin : gen_sum
            assign S[j] = A[j] ^ B[j] ^ P[j] ^ P[j+1] ^ P[j+2] ^ P[j+3] ^ P[j+4] ^ P[j+5] ^ P[j+6] ^ P[j+7] ^ P[j+8] ^ P[j+9] ^ P[j+10] ^ P[j+11] ^ P[j+12] ^ P[j+13] ^ P[j+14] ^ C16; // Sum bits 0-14
        end
    endgenerate
endmodule