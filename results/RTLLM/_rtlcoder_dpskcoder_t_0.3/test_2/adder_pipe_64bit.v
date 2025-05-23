module top_module (
    input wire clk,
    input wire rst_n,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output wire o_en
);

    adder_pipe_64bit #(
        .DATA_WIDTH(64),
        .STG_WIDTH(16)
    ) adder_pipe_64bit_inst (
        .clk(clk),
        .rst_n(rst_n),
        .i_en(1'b1),
        .adda(adda),
        .addb(addb),
        .result(result),
        .o_en(o_en)
    );

endmodule