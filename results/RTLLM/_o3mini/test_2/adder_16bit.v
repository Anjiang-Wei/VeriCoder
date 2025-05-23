module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);

    // Internal carry between the two 8-bit adders.
    wire carry_internal;

    // Lower 8-bit adder: Computes bits [7:0]
    adder_8bit adder_low (
        .a   (a[7:0]),
        .b   (b[7:0]),
        .Cin (Cin),
        .sum (y[7:0]),
        .Co  (carry_internal)
    );

    // Upper 8-bit adder: Computes bits [15:8]
    adder_8bit adder_high (
        .a   (a[15:8]),
        .b   (b[15:8]),
        .Cin (carry_internal),
        .sum (y[15:8]),
        .Co  (Co)
    );

endmodule