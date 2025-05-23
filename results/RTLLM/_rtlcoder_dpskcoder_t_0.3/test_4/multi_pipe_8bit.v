module top_module(
    input wire clk,
    input wire rst_n,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    input wire mul_en_in,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    multi_pipe_8bit multi_pipe_8bit_inst(
        .clk(clk),
        .rst_n(rst_n),
        .mul_a(mul_a),
        .mul_b(mul_b),
        .mul_en_in(mul_en_in),
        .mul_en_out(mul_en_out),
        .mul_out(mul_out)
    );

endmodule