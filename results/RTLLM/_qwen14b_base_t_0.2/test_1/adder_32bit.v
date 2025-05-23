module cla_16bit(A, B, C_in, S, C_out);
    input [15:0] A;
    input [15:0] B;
    input C_in;
    output [15:0] S;
    output C_out;

    wire [15:0] P, G;
    wire [4:0] C, C_gen, P_gen;

    // Propagate and Generate signals
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead signals
    assign C[0] = C_in;
    assign C_gen[0] = G[0];
    assign P_gen[0] = P[0];
    generate
        for (i = 1; i < 16; i = i + 1) begin
            assign C[i] = C_gen[i-1] | (P_gen[i-1] & C[i-1]);
            assign C_gen[i] = G[i] | (P[i] & C_gen[i-1]);
            assign P_gen[i] = P[i] & P_gen[i-1];
        end
    endgenerate

    // Sum and Carry out
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign S[i] = P[i] ^ C[i];
        end
    endgenerate

    assign C_out = C_gen[15] | (P_gen[15] & C[15]);
endmodule