module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);

    // Intermediate carry between the two 8-bit adders.
    wire carry_low;

    // Instantiate the lower 8-bit adder for bits [7:0].
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_low)
    );

    // Instantiate the upper 8-bit adder for bits [15:8].
    // Its carry-in is the carry-out of the lower adder.
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_low),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule