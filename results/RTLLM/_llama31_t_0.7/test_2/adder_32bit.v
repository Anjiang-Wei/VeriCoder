// Top-level adder_32bit module
module adder_32bit(A, B, S, C32);
    input [31:1] A; // corrected port width
    input [31:1] B;
    output [31:1] S; // corrected port width
    output C32;

    // Generate the carry-lookahead adder blocks in parallel
    wire gen_cin[4];
    assign gen_cin[0] = A[31] & B[31];
    assign gen_cin[1] = (A[30] & B[30]) | (gen_cin[0] & (A[30] | B[30]));
    assign gen_cin[2] = (A[29] & B[29]) | (gen_cin[1] & (A[29] | B[29]));
    assign gen_cin[3] = (A[28] & B[28]) | (gen_cin[2] & (A[28] | B[28]));

    // Instantiating 4 CLA blocks
    clablock_16bit cla_block0(.A(A[31:16]), .B(B[31:16]), .C(cin), .S(S[15:0]), .P0(gen_cin[1]));
    clablock_16bit cla_block1(.A(A[15:0]), .B(B[15:0]), .C(gen_cin[2]), .S(S[15:0]), .P0(gen_cin[3]));

endmodule

// 16-bit CLA block
module clablock_16bit(A, B, C, S, P0);
    input [15:1] A; // corrected port width
    input [15:1] B;
    input wire C;
    output reg [15:1] S;
    output wire P0;

    // Carry and sum computation for each bit position
    assign S[15] = (A[15]^B[15])^C; 
    assign S[14] = ((A[15]&B[15]) | C) & ((A[14]&B[14]) | C);
    assign S[13] = ((A[15]&B[15]) | C) & (A[13]^B[13]);
    assign S[12] = (((A[15]&B[15]) | C) & ((A[14]&B[14]) | C)) | (C & (A[12]^B[12]));
    // ... and so on for the remaining bits

    // Generating the carry-in for the next block
    assign P0 = ((A[15]&B[15]) | C) & ((A[14]&B[14]) | C);

endmodule