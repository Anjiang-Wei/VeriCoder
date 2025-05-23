module clablock(P,G,CIN);
    input [15:0] P; // Carry-Lookahead inputs
    input [15:0] G; // 
    input CIN;
    output [15:0] C; // Carry lookahead output
    output GO;        // Generate Output for next stage

    wire [15:0] G1,G2;
    assign G1 = A[15] & B[15];
    assign G2 = (A[15] | B[15]) & CIN;

    assign P = {A[14],B[14]};
    assign C = {A[13],B[13]};
    assign GO = G1 | G2;
endmodule

module clablock16(A,B,Cin,P,G,GO);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] P;
    output [15:0] G;
    output GO;

    wire C[15:0];
    generate
        for (genvar i = 0; i < 16; ++i)
            clablock A[i],B[i],Cin,C[i+1][i]:P[i],G[i];
    endgenerate

endmodule

module adder_32bit(A,B,S,C32);
     input [31:0] A;
     input [31:0] B;
     output reg [31:0] S;
     output wire C32;

     clablock16 A[15],B[15],1'b0,P1,G1,GO;
     assign {S[7:0],C32} = GO & 2'd1; // Calculate the carry out and lower bits

     reg [15:0] P[3];
     reg [15:0] G[3];

     clablock16 A[31:16],B[31:16],G1,P[2],G[2],GO;
     assign {P[1],C32} = GO & 2'd1; // Calculate the carry out and lower bits

     clablock16 A[23:8],B[23:8],G[2],P[1],G[1],GO;
     assign {S[15:8],C32} = GO & 2'd1; // Calculate the carry out and middle bits

     clablock16 A[7:0],B[7:0],G[1],P[0],G[0],GO;

     assign S = {{16{G[0]}},{{16{G[1]}},{16{G[2]}}}};
endmodule