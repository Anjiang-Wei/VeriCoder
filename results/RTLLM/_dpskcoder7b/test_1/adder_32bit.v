module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;
     
     wire [32:1] G; //Generate
     wire [32:1] P; //Propagate
     wire [32:1] C; //Carry
     wire [32:1] C_next; //Next carry
     
     genvar i;
     generate
         for (i = 0; i < 32; i = i + 1) begin: carry_lookahead_adder
             CLA_block cla_block (.A(A[i]), .B(B[i]), .G(G[i]), .P(P[i]), .C(C[i]), .C_next(C_next[i]));
         end
     endgenerate
     
     assign S = A ^ B ^ C;
     assign C32 = C_next[32];
     
endmodule