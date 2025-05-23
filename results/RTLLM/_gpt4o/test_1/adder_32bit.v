module adder_32bit(A, B, S, C32);
    input [32:1] A;    // 32-bit input operand A
    input [32:1] B;    // 32-bit input operand B
    output [32:1] S;   // 32-bit output sum
    output C32;        // Carry-out of the 32-bit addition

    wire C16;  // Carry-out from the first 16-bit block

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_block0 (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Cout(C16)
    );

    cla_16bit cla_block1 (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Cout(C32)
    );

endmodule

// 16-Bit Carry-Lookahead Adder (CLA) Module
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A;    // 16-bit input operand A
    input [16:1] B;    // 16-bit input operand B
    input Cin;         // Carry-in input
    output [16:1] S;   // 16-bit output sum
    output Cout;       // Carry-out of the addition

    wire [16:1] P;     // Propagate signals
    wire [16:1] G;     // Generate signals
    wire [16:0] C;     // Internal carry signals

    assign C[0] = Cin; // Initial carry is Cin

    // Generate (G) and Propagate (P) logic for each bit
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin: generate_pg
            assign P[i] = A[i] ^ B[i];   // Propagate = A XOR B
            assign G[i] = A[i] & B[i];   // Generate = A AND B
        end
    endgenerate

    // Carry-lookahead logic
    generate
        for (i = 1; i <= 16; i = i + 1) begin: carry_logic
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Sum calculation
    generate
        for (i = 1; i <= 16; i = i + 1) begin: sum_logic
            assign S[i] = P[i] ^ C[i-1]; // Sum = Propagate XOR Previous Carry
        end
    endgenerate

    // Final carry-out
    assign Cout = C[16];

endmodule