module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    wire [31:0] carry_16_0, carry_16_1;
    wire [15:0] sum_16_0, sum_16_1;
    wire [15:0] carry_16_0_out, carry_16_1_out;

    clablock_16bit cla16_0(.A(A[16:1]), .B(B[16:1]), .S(sum_16_0), .Cout(carry_16_0_out), .Cin(1'b0));
    clablock_16bit cla16_1(.A(A[32:17]), .B(B[32:17]), .S(sum_16_1), .Cout(carry_16_1_out), .Cin(carry_16_0_out));

    assign S[32:17] = sum_16_1;
    assign S[16:1] = sum_16_0;
    assign C32 = carry_16_1_out;

endmodule

module clablock_16bit(A, B, S, Cout, Cin);
    input [15:0] A;
    input [15:0] B;
    output [15:0] S;
    output Cout;
    input Cin;

    wire [15:0] P, G;
    wire [4:0] PG_gen, PG_prop;
    wire [4:0] PG_sum;

    genblk0: for (genvar i = 0; i < 16; i = i + 1) begin : genPG
        assign P[i] = A[i] ^ B[i];
        assign G[i] = A[i] & B[i];
    end

    // Generate carry lookahead signals
    genblk1: for (genvar i = 0; i < 5; i = i + 1) begin : genPGSignals
        assign PG_gen[i] = G[i*4 + 3] | (G[i*4 + 2] & (P[i*4 + 3] | G[i*4 + 1])) | (G[i*4 + 1] & (P[i*4 + 2] | (G[i*4] & (P[i*4 + 1] | P[i*4 + 3]))));
        assign PG_prop[i] = P[i*4 + 3] | (P[i*4 + 2] & (P[i*4 + 1] | P[i*4]));
    end

    // Summation of carry lookahead signals
    assign PG_sum[0] = Cin;
    genblk2: for (genvar i = 0; i < 4; i = i + 1) begin : genPGSum
        assign PG_sum[i + 1] = PG_sum[i] | PG_gen[i];
    end

    genblk3: for (genvar i = 0; i < 16; i = i + 1) begin : genSum
        assign S[i] = P[i] ^ PG_sum[i / 4];
    end

    assign Cout = PG_sum[4];

endmodule