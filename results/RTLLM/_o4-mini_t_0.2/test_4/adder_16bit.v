// 8‑bit ripple‑carry adder
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] y,
    output wire       Cout
);
    // simple behavioral implementation for the 8‑bit block
    assign {Cout, y} = a + b + Cin;
endmodule

// 16‑bit adder built from two 8‑bit adders
module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    wire c_mid;

    // lower 8 bits
    adder_8bit u0 (
        .a    (a[7:0]),
        .b    (b[7:0]),
        .Cin  (Cin),
        .y    (y[7:0]),
        .Cout (c_mid)
    );

    // upper 8 bits
    adder_8bit u1 (
        .a    (a[15:8]),
        .b    (b[15:8]),
        .Cin  (c_mid),
        .y    (y[15:8]),
        .Cout (Co)
    );
endmodule