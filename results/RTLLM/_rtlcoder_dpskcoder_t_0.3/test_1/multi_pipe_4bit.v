module top_module(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

wire [7:0] mul_out_temp;

multi_pipe_4bit #(
    .size(4)
) multi_pipe_4bit_inst (
    .clk(clk),
    .rst_n(rst_n),
    .mul_a(mul_a),
    .mul_b(mul_b),
    .mul_out(mul_out_temp)
);

assign mul_out = mul_out_temp;

endmodule