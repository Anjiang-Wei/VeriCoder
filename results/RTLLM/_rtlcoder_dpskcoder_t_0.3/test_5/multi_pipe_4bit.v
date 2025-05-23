module top_module(
    input wire clk,
    input wire rst_n,
    input wire [3:0] mul_a,
    input wire [3:0] mul_b,
    output reg [7:0] mul_out
);

    multi_pipe_4bit #(
        .size(4)
    ) multiplier (
        .clk(clk),
        .rst_n(rst_n),
        .mul_a(mul_a),
        .mul_b(mul_b),
        .mul_out(mul_out)
    );

endmodule