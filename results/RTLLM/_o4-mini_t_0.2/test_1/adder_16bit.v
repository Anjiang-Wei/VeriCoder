// 8‐bit adder: sum = a + b + Cin
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] sum,
    output wire      Cout
);
    // purely combinational
    assign {Cout, sum} = a + b + Cin;
endmodule

// 16‐bit adder built from two 8‐bit adders
module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    wire c8;

    // lower 8 bits
    adder_8bit u_lower (
        .a    (a[7:0]),
        .b    (b[7:0]),
        .Cin  (Cin),
        .sum  (y[7:0]),
        .Cout (c8)
    );

    // upper 8 bits, carry chained from lower
    adder_8bit u_upper (
        .a    (a[15:8]),
        .b    (b[15:8]),
        .Cin  (c8),
        .sum  (y[15:8]),
        .Cout (Co)
    );
endmodule