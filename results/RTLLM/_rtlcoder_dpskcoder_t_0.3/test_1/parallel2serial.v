module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

top_module top(
    .clk(clk),
    .rst_n(rst_n),
    .d(d),
    .valid_out(valid_out),
    .dout(dout)
);

endmodule