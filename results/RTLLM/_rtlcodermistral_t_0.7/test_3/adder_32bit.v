module CLA_16bit_adder(A,B,Cin,P,G,S,Cout);
     input [15:1] A;
     input [15:1] B;
     input Cin;
     output [15:1] P;
     output [15:1] G;
     output [15:1] S;
     output Cout;
     
     assign P = A ^ B;
     assign G = A & B;
     assign S = P ^ Cin;
     assign Cout = G | (P & Cin);
     
endmodule