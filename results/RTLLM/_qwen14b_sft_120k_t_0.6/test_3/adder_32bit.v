module adder_32bit(A, B, S, C32);
    input [31:0] A;
    input [31:0] B;
    output [31:0] S;
    output C32;

    wire [15:0] G16 [1:0], P16 [1:0], C16 [1:0];
    wire [31:16] G32, P32;
    wire C16_0, C16_1;

    // CLA blocks for 16-bit segments
    cla_16bit cla1(.A(A[15:0]), .B(B[15:0]), .G16(G16[0]), .P16(P16[0]), .S(S[15:0]), .C16(C16[0]));
    cla_16bit cla2(.A(A[31:16]), .B(B[31:16]), .G16(G16[1]), .P16(P16[1]), .S(S[31:16]), .C16(C16[1]));

    // Generate and propagate signals for 32-bit adder
    genblk1: begin
        genvar i;
        generate
            for (i = 0; i < 16; i = i + 1) begin : gen_XOR
                assign G32[i] = A[16+i] & B[16+i];
                assign P32[i] = A[16+i] ^ B[16+i];
            end
        endgenerate
    end

    // Generate carry signals for 32-bit adder
    assign C16_0 = C16[0] || (G16[0] & P16[0]);
    assign C16_1 = C16[1] || (G16[1] & P16[1]);

    assign C32 = C16_0 || (G32[15] & P32[15]) || (G32[14] & P32[14] & P32[15]) || (G32[13] & P32[13] & P32[14] & P32[15]) ||
                 (G32[12] & P32[12] & P32[13] & P32[14] & P32[15]) || (G32[11] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) ||
                 (G32[10] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) || (G32[9] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) ||
                 (G32[8] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) || (G32[7] & P32[7] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) ||
                 (G32[6] & P32[6] & P32[7] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) || (G32[5] & P32[5] & P32[6] & P32[7] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) ||
                 (G32[4] & P32[4] & P32[5] & P32[6] & P32[7] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) || (G32[3] & P32[3] & P32[4] & P32[5] & P32[6] & P32[7] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) ||
                 (G32[2] & P32[2] & P32[3] & P32[4] & P32[5] & P32[6] & P32[7] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) || (G32[1] & P32[1] & P32[2] & P32[3] & P32[4] & P32[5] & P32[6] & P32[7] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) ||
                 (G32[0] & P32[0] & P32[1] & P32[2] & P32[3] & P32[4] & P32[5] & P32[6] & P32[7] & P32[8] & P32[9] & P32[10] & P32[11] & P32[12] & P32[13] & P32[14] & P32[15]) || C16_1;

endmodule

module cla_16bit(A, B, G16, P16, S, C16);
    input [15:0] A;
    input [15:0] B;
    output [15:0] G16;
    output [15:0] P16;
    output [15:0] S;
    output C16;

    wire [15:0] P16_inter, G16_inter;
    wire [15:0] C16_inter;

    genblk1: begin
        genvar i;
        generate
            for (i = 0; i < 16; i = i + 1) begin : gen_XOR
                assign P16_inter[i] = A[i] ^ B[i];
                assign G16_inter[i] = A[i] & B[i];
            end
        endgenerate
    end

    // Generate carry signals for 16-bit adder
    assign C16 = G16_inter[15] | (G16_inter[14] & P16_inter[15]) | (G16_inter[13] & P16_inter[14] & P16_inter[15]) | (G16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) |
                 (G16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) | (G16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) |
                 (G16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) | (G16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) |
                 (G16_inter[7] & P16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) | (G16_inter[6] & P16_inter[7] & P16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) |
                 (G16_inter[5] & P16_inter[6] & P16_inter[7] & P16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) | (G16_inter[4] & P16_inter[5] & P16_inter[6] & P16_inter[7] & P16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) |
                 (G16_inter[3] & P16_inter[4] & P16_inter[5] & P16_inter[6] & P16_inter[7] & P16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) | (G16_inter[2] & P16_inter[3] & P16_inter[4] & P16_inter[5] & P16_inter[6] & P16_inter[7] & P16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) |
                 (G16_inter[1] & P16_inter[2] & P16_inter[3] & P16_inter[4] & P16_inter[5] & P16_inter[6] & P16_inter[7] & P16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]) | (G16_inter[0] & P16_inter[1] & P16_inter[2] & P16_inter[3] & P16_inter[4] & P16_inter[5] & P16_inter[6] & P16_inter[7] & P16_inter[8] & P16_inter[9] & P16_inter[10] & P16_inter[11] & P16_inter[12] & P16_inter[13] & P16_inter[14] & P16_inter[15]);

    assign S = {1'b0, C16} ^ P16_inter;
    assign G16 = G16_inter;
    assign P16 = P16_inter;

endmodule