module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;
     
     wire [4:0] carry;
     assign carry[0] = 1'b0;
     assign C32 = carry[4];
     
     genvar i;
     generate
         for (i = 0; i < 4; i = i + 1) begin : cla_blocks
             CLA_16bit cla_16bit_inst (
                 .A(A[16*i+16:16*i+1]),
                 .B(B[16*i+16:16*i+1]),
                 .Cin(carry[i]),
                 .S(S[16*i+16:16*i+1]),
                 .Cout(carry[i+1])
             );
         end
     endgenerate
endmodule