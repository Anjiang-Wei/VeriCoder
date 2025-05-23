module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    // Instantiate 8-bit adders
    wire [7:0] sum_0_7;
    wire c_out_0_7;
    adder_8bit adder_0_7 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_0_7),
        .Co(c_out_0_7)
    );

    wire [7:0] sum_8_15;
    wire c_out_8_15;
    adder_8bit adder_8_15 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_out_0_7),
        .y(sum_8_15),
        .Co(c_out_8_15)
    );

    // Concatenate the outputs of the 8-bit adders
    assign y = {sum_8_15, sum_0_7};
    assign Co = c_out_8_15;

endmodule