module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);

    // Internal wire to connect the carry-out of the lower adder to the carry-in of the upper adder.
    wire carry8;

    // Instantiate the lower 8-bit adder (for bits 7:0) with the provided carry-in.
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry8)
    );

    // Instantiate the upper 8-bit adder (for bits 15:8) with the carried-out value from the lower adder.
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry8),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule