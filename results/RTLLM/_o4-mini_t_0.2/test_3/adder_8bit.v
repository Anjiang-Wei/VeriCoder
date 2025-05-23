//-----------------------------------------------------------------------------
// Full‐adder bit‐level module
//-----------------------------------------------------------------------------
module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Sum is XOR of inputs
    assign sum  = a ^ b ^ cin;
    // Carry‐out is majority of inputs
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule


//-----------------------------------------------------------------------------
// 8‐bit ripple‐carry adder using 8 full_adder instances
//-----------------------------------------------------------------------------
module adder_8bit(
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    // Intermediate carry wires
    wire c0, c1, c2, c3, c4, c5, c6, c7;

    // Instantiate 8 full-adders for each bit
    full_adder fa0 (
        .a    (a[0]),
        .b    (b[0]),
        .cin  (cin),
        .sum  (sum[0]),
        .cout (c0)
    );

    full_adder fa1 (
        .a    (a[1]),
        .b    (b[1]),
        .cin  (c0),
        .sum  (sum[1]),
        .cout (c1)
    );

    full_adder fa2 (
        .a    (a[2]),
        .b    (b[2]),
        .cin  (c1),
        .sum  (sum[2]),
        .cout (c2)
    );

    full_adder fa3 (
        .a    (a[3]),
        .b    (b[3]),
        .cin  (c2),
        .sum  (sum[3]),
        .cout (c3)
    );

    full_adder fa4 (
        .a    (a[4]),
        .b    (b[4]),
        .cin  (c3),
        .sum  (sum[4]),
        .cout (c4)
    );

    full_adder fa5 (
        .a    (a[5]),
        .b    (b[5]),
        .cin  (c4),
        .sum  (sum[5]),
        .cout (c5)
    );

    full_adder fa6 (
        .a    (a[6]),
        .b    (b[6]),
        .cin  (c5),
        .sum  (sum[6]),
        .cout (c6)
    );

    full_adder fa7 (
        .a    (a[7]),
        .b    (b[7]),
        .cin  (c6),
        .sum  (sum[7]),
        .cout (cout)
    );

endmodule