// 16-bit CLA block
module clablock(A,B,Cin,G,P,S,Cout);
    input [15:0] A; // First operand
    input [15:0] B; // Second operand
    input Cin;       // Carry-in to the block
    output G[1:0];   // Generation signals for carry lookahead
    output P[15:0];  // Propagation signals for carry lookahead
    output S[15:0];  // Sum of A and B with carry propagation
    output Cout;     // Carry-out from the block

    // Calculate generation and propagation signals
    assign G[0] = (A[0]^B[0]);
    assign P[0] = (A[0]&B[0]);

    // Generate carry lookahead for each bit position in this 16-bit block
    generate
        for (genvar i=1; i<15; i++) begin
            // Calculate generation and propagation signals for the current bit
            assign G[i] = (P[i-1]|(A[i]^B[i]));
            assign P[i] = (A[i]&B[i]);
        end
    endgenerate

    // Combine all the bits of A, B, Cin, G, and P to compute S and Cout
    generate
        for (genvar i=0; i<15; i++) begin
            assign S[i] = (P[i]^((A[i]&G[i])^(B[i]&G[i])));
        end

        // The last bit of the sum is computed from all previous bits
        assign S[15] = P[14];
    endgenerate

    // Calculate carry-out of this block
    assign Cout = G[15];

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(A,B,S,C32);
    input [31:0] A;       // First operand
    input [31:0] B;       // Second operand
    output [31:0] S;      // Sum of A and B with carry propagation
    output C32;           // Carry-out from the block

    wire [15:0] G1, P1, S1, Cout1;
    wire [15:0] G2, P2, S2, Cout2;

    clablock CLABLOCK1(A[31:16], B[31:16], 0, G1, P1, S1, Cout1);
    clablock CLABLOCK2(A[15:0], B[15:0], Cout1, G2, P2, S2, C32);

    // Combine the two sums to get the final sum
    assign {S,C32} = {S2,16'b0};
endmodule