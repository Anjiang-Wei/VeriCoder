module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     wire [31:1] G, P, C;
     
     genvar i;
     generate
        for(i=1; i<=32; i=i+1) begin: carry_lookahead
            CLA_block cla(.A(A[i]), .B(B[i]), .Cin(C[i-1]), .Sum(S[i]), .G(G[i]), .P(P[i]), .Cout(C[i]));
        end
     endgenerate

     assign C32 = C[32];

endmodule

module CLA_block(A,B,Cin,Sum,G,P,Cout);
     input A, B, Cin;
     output Sum, G, P, Cout;

     assign {Cout, Sum} = A + B + Cin;
     assign G = A & B;
     assign P = A | B;

endmodule