module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;
     wire [16:1] G,P,C;
     assign G = A[16:1] ^ B[16:1];
     assign P = A[16:1] & B[16:1];
     assign C[1] = P[1];
     genvar i;
     generate
       for (i = 2; i <= 16; i = i + 1) begin : gen_block
         assign G[i] = G[i-1] | (P[i-1] & G[i-1]);
         assign P[i] = A[i] & B[i];
         assign C[i] = P[i] | (G[i-1] & (P[i-1] | C[i-1]));
       end
     endgenerate
     assign S = A + B + C;
     assign C32 = C[16];
endmodule