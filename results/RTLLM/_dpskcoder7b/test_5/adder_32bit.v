module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    wire [32:1] S_intermediate;
    wire [7:0] C;

    // Instantiate 4-bit CLA blocks
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : cla4bit
            cla_4bit cla4bit_instance (
                .A(A[4*i+3:4*i]),
                .B(B[4*i+3:4*i]),
                .S(S_intermediate[4*i+3:4*i]),
                .C_out(C[i])
            );
        end
    endgenerate

    // Connect the carry-outs and sum outputs
    assign S[32:1] = S_intermediate[32:1];
    assign C32 = C[7];
endmodule