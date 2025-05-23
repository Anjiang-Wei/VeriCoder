module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     // Internal signals for carry lookahead
     wire [15:0] P1, G1, P2, G2;
     wire [15:0] C1, C2;
     wire [31:0] C;

     // Instantiate two 16-bit CLA blocks
     cla_16bit CLA1 (A[16:1], B[16:1], S[16:1], C1[15:0], P1[15:0], G1[15:0]);
     cla_16bit CLA2 (A[32:17], B[32:17], S[32:17], C2[15:0], P2[15:0], G2[15:0]);

     // Generate carry-in for the second CLA block
     assign C[16] = (G1[15] | (P1[15] & C1[14]));

     // Generate carry signals for the second CLA block
     genvar i;
     generate
         for (i = 17; i <= 31; i = i + 1) begin
             assign C[i] = (G1[i-1] | (P1[i-1] & C[i-1]));
         end
     endgenerate

     // Generate carry-out for the 32-bit adder
     assign C32 = (G2[15] | (P2[15] & C[31]));

     // Assign carry signals to the second CLA block
     assign C1[0] = 1'b0;
     assign C2[0] = C[16];

endmodule