module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    // Instantiate 8-bit adders
    wire [7:0] sum_0, sum_1;
    wire c_out_0, c_out_1;

    adder_8bit adder_0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_0),
        .Co(c_out_0)
    );

    adder_8bit adder_1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_out_0),
        .y(sum_1),
        .Co(c_out_1)
    );

    // Concatenate the outputs of the 8-bit adders
    assign y = {sum_1, sum_0};
    assign Co = c_out_1;

endmodule