// The 16-bit carry-lookahead adder block.
module clab(A,B,C,S,C32);
     input [15:1] A;
     input [15:1] B;
     input C;
     output [15:1] S;
     output C32;
     
     wire [15:1] P, G;
     wire [15:0] C1, C2;
     wire [15:1] S1;
     
     assign P = A ^ B;
     assign G = A & B;
     
     assign C1 = {C, 1'b0};
     assign C2 = {C1[15], 1'b0};
     assign C32 = C1[15];
     
     assign S1 = A ^ B ^ C;
     
     assign S = {S1[0], S1[1:0], S1[2:0], S1[3:1], S1[4:2], S1[5:3], S1[6:4], S1[7:5], S1[8:6], S1[9:7], S1[10:8], S1[11:9], S1[12:10], S1[13:11], S1[14:12], S1[15:14]};
     
endmodule