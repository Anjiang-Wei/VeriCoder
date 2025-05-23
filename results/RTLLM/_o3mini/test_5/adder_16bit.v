module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    // Internal signal to connect the carry-out from lower 8-bit adder to the carry-in of the upper 8-bit adder.
    wire mid_carry;

    // Instantiate lower 8-bit adder instance.
    adder_8bit adder_low (
        .a   (a[7:0]),
        .b   (b[7:0]),
        .Cin (Cin),
        .y   (y[7:0]),
        .Co  (mid_carry)
    );

    // Instantiate upper 8-bit adder instance.
    adder_8bit adder_high (
        .a   (a[15:8]),
        .b   (b[15:8]),
        .Cin (mid_carry),
        .y   (y[15:8]),
        .Co  (Co)
    );

endmodule