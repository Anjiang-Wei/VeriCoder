module adder_32bit(A, B, S, C32);
    input [32:1] A;             // 32-bit input operand A
    input [32:1] B;             // 32-bit input operand B
    output [32:1] S;            // 32-bit output sum
    output C32;                 // Carry-out
    
    wire C16;                   // Carry-out from the first 16-bit CLA block
    
    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_16bit_1 (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),            // Since it's LSB, carry-in is 0
        .S(S[16:1]),
        .Cout(C16)
    );
    
    cla_16bit cla_16bit_2 (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),             // Carry-out of first CLA block becomes carry-in for this block
        .S(S[32:17]),
        .Cout(C32)
    );
    
endmodule


// 16-bit Carry-Lookahead Adder (CLA)
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A;             // 16-bit input operand A
    input [16:1] B;             // 16-bit input operand B
    input Cin;                  // Carry-in
    output [16:1] S;            // 16-bit output sum
    output Cout;                // Carry-out of the 16-bit block
    
    wire [16:1] P, G;           // Generate (G) and Propagate (P) signals
    wire [16:0] C;              // Internal carry signals
    
    // Generate and propagate signals
    assign P = A ^ B;           // Propagate: P = A XOR B
    assign G = A & B;           // Generate:  G = A AND B
    
    // Calculate carries
    assign C[0] = Cin;          // Carry-in to the block
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
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
    assign C[16] = G[16] | (P[16] & C[15]);
    
    // Sum calculations
    assign S = P ^ C[15:0];     // Sum: S = P XOR Carry
    
    // Final carry-out
    assign Cout = C[16];
    
endmodule