module adder_32bit(A,B,S,C32);
    input [31:0] A;    // 32-bit input operand A
    input [31:0] B;    // 32-bit input operand B
    output [31:0] S;   // 32-bit output sum
    output C32;        // Carry-out output

    wire [1:0] C;      // Carry signals between 16-bit adders

    // Instantiate two 16-bit CLA blocks
    cla_16bit CLA1 (
        .A(A[15:0]),
        .B(B[15:0]),
        .C_in(1'b0),      // No carry input for the first 16-bit adder
        .S(S[15:0]),
        .C_out(C[0])
    );

    cla_16bit CLA2 (
        .A(A[31:16]),
        .B(B[31:16]),
        .C_in(C[0]),      // Carry out from the first 16-bit adder
        .S(S[31:16]),
        .C_out(C32)       // Carry out from the second 16-bit adder
    );

endmodule

// 16-bit Carry Lookahead Adder
module cla_16bit(A,B,C_in,S,C_out);
    input [15:0] A;    // 16-bit input operand A
    input [15:0] B;    // 16-bit input operand B
    input C_in;        // Carry input
    output [15:0] S;   // 16-bit output sum
    output C_out;      // Carry output

    wire [15:0] P;     // Propagate signals
    wire [15:0] G;     // Generate signals
    wire [15:0] C;     // Carry signals

    // Generate and propagate signals
    assign P = A ^ B;  // Propagate
    assign G = A & B;  // Generate
    
    // Generate carry signals
    assign C[0] = G[0] | (P[0] & C_in);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);
    assign C[5] = G[5] | (P[5] & C[4]);
    assign C[6] = G[6] | (P[6] & C[5]);
    assign C[7] = G[7] | (P[7] & C[6]);
    assign C[8] = G[8] | (P[8] & C[7]);
    assign C[9] = G[9] | (P[9] & C[8]);
    assign C[10] = G[10] | (P[10] & C[9]);
    assign C[11] = G[11] | (P[11] & C[10]);
    assign C[12] = G[12] | (P[12] & C[11]);
    assign C[13] = G[13] | (P[13] & C[12]);
    assign C[14] = G[14] | (P[14] & C[13]);
    assign C[15] = G[15] | (P[15] & C[14]);
    
    // Create sum output
    assign S = P ^ {C_in, C[15:1]}; // Sum = Propagate ^ Carry
    
    // Final carry out
    assign C_out = G[15] | (P[15] & C[14]);

endmodule