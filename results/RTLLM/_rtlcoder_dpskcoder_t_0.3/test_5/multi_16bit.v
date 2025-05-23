module top_module(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

wire [31:0] multi_out;
wire multi_done;

multi_16bit multi(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .ain(ain),
    .bin(bin),
    .yout(multi_out),
    .done(multi_done)
);

assign yout = multi_out;
assign done = multi_done;

endmodule