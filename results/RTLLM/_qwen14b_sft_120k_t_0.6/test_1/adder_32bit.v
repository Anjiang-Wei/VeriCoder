module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    wire [16:1] C;
    wire [15:1] C16;

    // Instantiate 16-bit CLA blocks for 32-bit addition
    cla_16bit cla16_1 (.A(A[16:1]), .B(B[16:1]), .S(S[16:1]), .C1(C[16:1]), .C16(C16[15:1]));
    cla_16bit cla16_2 (.A(A[32:17]), .B(B[32:17]), .S(S[32:17]), .C1(C[32:17]), .C16(C16[31:16]));

    // Carry propagation for the 32-bit adder
    assign C32 = C16[31] | (C16[31] & C16[15]);
endmodule

module cla_16bit(A, B, S, C1, C16);
    input [16:1] A;
    input [16:1] B;
    output [16:1] S;
    output [16:1] C1;
    output [15:1] C16;

    wire [15:1] P, G;
    wire [15:1] C;

    // Generate and propagate signals
    generate
        genvar i;
        for (i = 1; i <= 15; i = i + 1) begin : gen_P_G
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Carry computation
    assign C[16] = 1'b0;
    assign C[15] = G[15] | (P[15] & C[14]);
    genvar j;
    generate
        for (j = 14; j >= 1; j = j - 1) begin : gen_C
            assign C[j] = G[j] | (P[j] & (G[j+1] | (P[j+1] & C[j+2])));
        end
    endgenerate

    // Sum computation
    generate
        for (i = 1; i <= 15; i = i + 1) begin : gen_S
            assign S[i] = P[i] ^ C[i];
        end
    endgenerate
    assign S[16] = P[16] ^ C[16];

    // Output carry signals
    assign C1[16] = 1'b0;
    assign C1[15] = C[15];
    genvar k;
    generate
        for (k = 14; k >= 1; k = k - 1) begin : gen_C1
            assign C1[k] = G[k] | (P[k] & (G[k+1] | (P[k+1] & C1[k+2])));
        end
    endgenerate
    assign C1[1] = G[1] | (P[1] & G[2]);

    // Generate C16 from C1
    assign C16[15] = C1[15];
    genvar l;
    generate
        for (l = 14; l >= 1; l = l - 1) begin : gen_C16
            assign C16[l] = G[l] | (P[l] & (G[l+1] | (P[l+1] & C16[l+2])));
        end
    endgenerate
    assign C16[1] = G[1] | (P[1] & G[2]);
endmodule