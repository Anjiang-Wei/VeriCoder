// Top module: 32-bit Carry-Lookahead Adder
module adder_32bit(A, B, S, C32);
    input [32:1] A;         // 32-bit input operand A
    input [32:1] B;         // 32-bit input operand B
    output [32:1] S;        // 32-bit sum output
    output C32;             // Carry-out output

    wire C16;               // Carry-out from first 16-bit CLA block

    // Instantiate two 16-bit CLA blocks
    cla_16bit U1 (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Cout(C16));
    cla_16bit U2 (.A(A[32:17]), .B(B[32:17]), .Cin(C16), .S(S[32:17]), .Cout(C32));

endmodule

// 16-bit Carry-Lookahead Adder Module
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A;         // 16-bit input operand A
    input [16:1] B;         // 16-bit input operand B
    input Cin;              // Carry-in (input)
    output [16:1] S;        // 16-bit sum output
    output Cout;            // Carry-out output

    wire [16:1] P;          // Propagate signals
    wire [16:1] G;          // Generate signals
    wire [16:0] C;          // Internal carry signals

    assign C[0] = Cin;      // Initial carry-in

    // Generate and Propagate logic
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : generate_PG
            assign P[i] = A[i] ^ B[i];  // Propagate: A XOR B
            assign G[i] = A[i] & B[i];  // Generate: A AND B
        end
    endgenerate

    // Carry-Lookahead logic
    generate
        for (i = 1; i <= 16; i = i + 1) begin : generate_Carry
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Sum calculation
    generate
        for (i = 1; i <= 16; i = i + 1) begin : generate_Sum
            assign S[i] = P[i] ^ C[i-1];  // Sum: Propagate XOR Carry-in
        end
    endgenerate

    // Final carry-out
    assign Cout = C[16];

endmodule