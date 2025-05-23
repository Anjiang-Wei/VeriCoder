module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     wire [16:0] C;
     wire [16:1] P, G;

     assign C[1] = 1'b0;

     genvar i;
     generate
         for (i = 0; i < 2; i = i + 1) begin : cla_blocks
             CLA_Block cla_block(
                 .G(G[(i+1)*16:(i*16+1)]),
                 .P(P[(i+1)*16:(i*16+1)]),
                 .C(C[(i+2)*16:(i*16+1)])
             );
         end
     endgenerate

     genvar j;
     generate
         for (j = 0; j < 16; j = j + 1) begin : sum_bits
             assign S[j+1] = A[j+1] ^ B[j+1] ^ C[j+1];
         end
     endgenerate

     assign S[32] = A[32] ^ B[32] ^ C[32];
     assign C32 = C[32];

     assign G[16:1] = A[16:1] & B[16:1];
     assign P[16:1] = A[16:1] | B[16:1];
endmodule