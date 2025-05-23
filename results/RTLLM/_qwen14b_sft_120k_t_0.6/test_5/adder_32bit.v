module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    wire [15:0] C16, G16, P16;
    wire [31:0] S16;
    wire C16_out;

    // Instantiate 16-bit carry-lookahead adders
    CLA_16 adder_0 (.A(A[15:0]), .B(B[15:0]), .G(G16[15:0]), .P(P16[15:0]), .S(S16[15:0]), .C(C16[0]));
    CLA_16 adder_1 (.A(A[31:16]), .B(B[31:16]), .G(G16[31:16]), .P(P16[31:16]), .S(S16[31:16]), .C(C16[1]));

    // Generate carry lookahead signals
    assign C16_out = C16[1] | (G16[15] & P16[15]) | (G16[15] & G16[14] & P16[14]) | (G16[15] & G16[14] & G16[13] & P16[13]) | (G16[15] & G16[14] & G16[13] & G16[12] & P16[12]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & P16[11]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & P16[10]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & P16[9]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & G16[8] & P16[8]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & G16[8] & G16[7] & P16[7]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & G16[8] & G16[7] & G16[6] & P16[6]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & G16[8] & G16[7] & G16[6] & G16[5] & P16[5]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & G16[8] & G16[7] & G16[6] & G16[5] & G16[4] & P16[4]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & G16[8] & G16[7] & G16[6] & G16[5] & G16[4] & G16[3] & P16[3]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & G16[8] & G16[7] & G16[6] & G16[5] & G16[4] & G16[3] & G16[2] & P16[2]) | (G16[15] & G16[14] & G16[13] & G16[12] & G16[11] & G16[10] & G16[9] & G16[8] & G16[7] & G16[6] & G16[5] & G16[4] & G16[3] & G16[2] & G16[1] & P16[1]);

    assign S = S16;
    assign C32 = C16_out;

    // 16-bit Carry-Lookahead Adder module
    module CLA_16(A, B, G, P, S, C);
        input [15:0] A, B;
        output [15:0] G, P, S;
        output C;

        wire [15:0] g, p;
        wire [3:0] g4, p4;
        wire [3:0] g8, p8;

        genvar i;
        generate
            for (i = 0; i < 16; i = i + 1) begin : gen_g_p
                assign g[i] = A[i] & B[i];
                assign p[i] = A[i] ^ B[i];
            end
        endgenerate

        // Generate group and propagate signals for each 4-bit block
        assign g4[0] = g[0] | g[1] | g[2] | g[3];
        assign p4[0] = p[0] & p[1] & p[2] & p[3];
        assign g4[1] = g[4] | g[5] | g[6] | g[7];
        assign p4[1] = p[4] & p[5] & p[6] & p[7];
        assign g4[2] = g[8] | g[9] | g[10] | g[11];
        assign p4[2] = p[8] & p[9] & p[10] & p[11];
        assign g4[3] = g[12] | g[13] | g[14] | g[15];
        assign p4[3] = p[12] & p[13] & p[14] & p[15];

        // Generate group and propagate signals for each 8-bit block
        assign g8[0] = g4[0] | g4[1];
        assign p8[0] = p4[0] & p4[1];
        assign g8[1] = g4[2] | g4[3];
        assign p8[1] = p4[2] & p4[3];

        // Generate carry lookahead for each 16-bit block
        assign G = {g8[1], g8[0]};
        assign P = {p8[1], p8[0]};

        // Generate sum bits
        genvar j;
        generate
            for (j = 0; j < 16; j = j + 1) begin : gen_s
                assign S[j] = p[j] ^ C;
            end
        endgenerate

        assign C = G[1] | (G[0] & P[1]) | (G[0] & G[1] & P[0]);
    endmodule
endmodule