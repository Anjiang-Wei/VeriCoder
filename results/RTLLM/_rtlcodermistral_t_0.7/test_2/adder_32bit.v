module adder_16bit(A,B,S,C);
     input [15:1] A;
     input [15:1] B;
     output [15:1] S;
     output C;

     assign S = A ^ B;
     assign C = A & B;

endmodule