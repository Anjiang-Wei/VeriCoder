module adder_32bit(A, B, S, C32);
    input [31:0] A; // 32-bit input operand A
    input [31:0] B; // 32-bit input operand B
    output [31:0] S; // 32-bit output sum
    output C32; // Carry-out output

    wire [1:0] C; // Carry bits from lower 16-bit adders

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla0(.A(A[15:0]), .B(B[15:0]), .C_in(1'b0), .S(S[15:0]), .C_out(C[0]));
    cla_16bit cla1(.A(A[31:16]), .B(B[31:16]), .C_in(C[0]), .S(S[31:16]), .C_out(C32));

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(A, B, C_in, S, C_out);
    input [15:0] A;     // 16-bit input operand A
    input [15:0] B;     // 16-bit input operand B
    input C_in;         // Carry-in
    output [15:0] S;    // 16-bit output sum
    output C_out;       // Carry-out

    wire [15:0] G;      // Generate signals
    wire [15:0] P;      // Propagate signals
    wire [3:0] C;       // Carry bits

    // Generate and propagate definitions
    assign G = A & B;               // Generate
    assign P = A ^ B;               // Propagate

    // Carry logic
    assign C[0] = G[0] | (P[0] & C_in);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    
    // Final carry-out
    assign C_out = G[15] | (P[15] & C[3]);

    // Sum calculation
    assign S[0] = P[0] ^ C_in;
    assign S[1] = P[1] ^ C[0];
    assign S[2] = P[2] ^ C[1];
    assign S[3] = P[3] ^ C[2];
    assign S[4] = P[4] ^ C[3];
    assign S[5] = P[5] ^ C[3];
    assign S[6] = P[6] ^ C[3];
    assign S[7] = P[7] ^ C[3];
    assign S[8] = P[8] ^ C[3];
    assign S[9] = P[9] ^ C[3];
    assign S[10] = P[10] ^ C[3];
    assign S[11] = P[11] ^ C[3];
    assign S[12] = P[12] ^ C[3];
    assign S[13] = P[13] ^ C[3];
    assign S[14] = P[14] ^ C[3];
    assign S[15] = P[15] ^ C[3];
    
endmodule