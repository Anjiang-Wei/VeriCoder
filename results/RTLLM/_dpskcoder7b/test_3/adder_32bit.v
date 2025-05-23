module adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

    wire [32:1] G;
    wire [32:1] P;
    wire [32:1] C_internal;

    genvar i;
    generate 
        for(i=1; i<=32; i=i+1) begin : each_bit
            adder_16bit CLA(
                .A(A[i]),
                .B(B[i]),
                .S(S[i]),
                .C32(C_internal[i])
            );
        end
    endgenerate

    // Carry Lookahead Logic
    C_internal[1] = G[1] | (P[1] & C32);
    for(i=2; i<=32; i=i+1) begin : cla_logic
        C_internal[i] = G[i] | (P[i] & (C_internal[i-1] | G[i-1]));
    end

    assign C32 = C_internal[32];
endmodule