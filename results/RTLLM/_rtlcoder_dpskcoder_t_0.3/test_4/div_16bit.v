module top_module(
    input wire clk,
    input wire reset,
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

div_16bit div_inst(
    .A(A),
    .B(B),
    .result(result),
    .odd(odd)
    );

endmodule