module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A;
    input [16:1] B;
    input Cin;
    output [16:1] S;
    output Cout;

    wire [16:1] P, G; // Propagate and Generate
    wire [16:0] C;    // Carry signals

    assign C[0] = Cin;

    // Generate Propagate and Generate for each bit
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin
            assign P[i] = A[i] ^ B[i];  // XOR for propagate
            assign G[i] = A[i] & B[i];  // AND for generate
        end
    endgenerate

    // Carry-lookahead logic
    // C[i] = G[i-1] + (P[i-1] & C[i-1])
    generate
        for (i = 1; i <= 16; i = i + 1) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Compute sum
    generate
        for (i = 1; i <= 16; i = i + 1) begin
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    // Final carry-out
    assign Cout = C[16];

endmodule

// Top-level 32-bit Carry-Lookahead Adder
module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    wire C16; // Carry-out from the lower 16-bit CLA

    // Lower 16-bit CLA
    cla_16bit CLA_Low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    // Upper 16-bit CLA
    cla_16bit CLA_High (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule