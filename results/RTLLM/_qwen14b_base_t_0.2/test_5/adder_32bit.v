module cla_16bit (A, B, C_in, S, C_out);
    input [15:0] A;
    input [15:0] B;
    input C_in;
    output [15:0] S;
    output C_out;

    wire [3:0] G, P;
    wire [3:0] C_out_internal;

    // Generate and Propagate signals
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] ^ B[0];
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];

    // Generate and Propagate for the rest of the bits
    generate
        genvar i;
        for (i = 4; i < 16; i = i + 4) begin
            assign G[i/4] = A[i] & B[i] | A[i+1] & B[i+1] | A[i+2] & B[i+2] | A[i+3] & B[i+3];
            assign P[i/4] = A[i] ^ B[i] | A[i+1] ^ B[i+1] | A[i+2] ^ B[i+2] | A[i+3] ^ B[i+3];
        end
    endgenerate

    // Carry-out generation
    assign C_out_internal[0] = G[0] | P[0] & C_in;
    assign C_out_internal[1] = G[1] | P[1] & G[0] | P[1] & P[0] & C_in;
    assign C_out_internal[2] = G[2] | P[2] & G[1] | P[2] & P[1] & G[0] | P[2] & P[1] & P[0] & C_in;
    assign C_out_internal[3] = G[3] | P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[2] & P[1] & G[0] | P[3] & P[2] & P[1] & P[0] & C_in;

    // Sum generation
    assign S[0] = P[0] ^ C_in;
    assign S[1] = P[1] ^ C_out_internal[0];
    assign S[2] = P[2] ^ C_out_internal[1];
    assign S[3] = P[3] ^ C_out_internal[2];
    generate
        genvar j;
        for (j = 4; j < 16; j = j + 1) begin
            assign S[j] = P[j/4] ^ C_out_internal[j/4];
        end
    endgenerate

    // Final carry-out
    assign C_out = C_out_internal[3];

endmodule