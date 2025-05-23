// 8‑bit ripple carry adder
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] sum,
    output wire       Co
);
    // simple combinational addition
    assign {Co, sum} = a + b + Cin;
endmodule

// 16‑bit adder built from two 8‑bit adders
module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    // intermediate carry between the two 8‑bit adders
    wire c_mid;

    // instantiate lower 8 bits
    adder_8bit u_lower (
        .a   (a[7:0]),
        .b   (b[7:0]),
        .Cin (Cin),
        .sum (y[7:0]),
        .Co  (c_mid)
    );

    // instantiate upper 8 bits
    adder_8bit u_upper (
        .a   (a[15:8]),
        .b   (b[15:8]),
        .Cin (c_mid),
        .sum (y[15:8]),
        .Co  (Co)
    );
endmodule