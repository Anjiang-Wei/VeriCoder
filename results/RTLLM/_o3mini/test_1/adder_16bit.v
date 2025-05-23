module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire      Cin,
    output wire [15:0] y,
    output wire     Co
);

    wire c8; // Internal carry from the lower 8 bits to the upper 8 bits

    // Instantiate the lower 8-bit adder (bits [7:0])
    adder_8bit lower_adder (
        .a   (a[7:0]),
        .b   (b[7:0]),
        .Cin (Cin),
        .sum (y[7:0]),
        .Cout(c8)
    );

    // Instantiate the upper 8-bit adder (bits [15:8])
    adder_8bit upper_adder (
        .a   (a[15:8]),
        .b   (b[15:8]),
        .Cin (c8),
        .sum (y[15:8]),
        .Cout(Co)
    );

endmodule