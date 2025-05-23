module cla_16bit(A, B, C_in, S, C_out);
    input [15:0] A;
    input [15:0] B;
    input C_in;
    output [15:0] S;
    output C_out;

    wire [3:0] G, P;
    wire [4:0] C;

    // Generate and propagate signals
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate

    // Carry generation
    assign C[0] = C_in;
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin
            assign C[j+1] = G[4*j] | (P[4*j] & (G[4*j+1] | (P[4*j+1] & (G[4*j+2] | (P[4*j+2] & G[4*j+3])))));
        end
    endgenerate

    // Sum calculation
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin
            assign S[k] = P[k] ^ C[k/4];
        end
    endgenerate

    // Final carry-out
    assign C_out = C[4];

endmodule