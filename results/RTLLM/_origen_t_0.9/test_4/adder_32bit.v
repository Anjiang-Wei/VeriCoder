module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    wire [16:1] C;
    wire [4:0] G, P;

    // Generate and Propagate signals
    assign G = A[16:1] & B[16:1];
    assign P = A[16:1] | B[16:1];

    // Carry-lookahead logic
    assign C[1] = G[1];
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & C[1]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & C[1]);
    assign C[5] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & C[1]);

    // CLA adder for bits 1-15
    cla_16bit cla1 (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(C[1]),
        .S(S[16:1]),
        .Cout(C[16])
    );

    // CLA adder for bits 17-32
    cla_16bit cla2 (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C[16]),
        .S(S[32:17]),
        .Cout(C[32])
    );

    // Carry-out
    assign C32 = C[32];

endmodule