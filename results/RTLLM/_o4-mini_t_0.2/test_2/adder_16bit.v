// 8‐bit ripple‐carry adder
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] y,
    output wire       Co
);
    // simple combinational adder using Verilog arithmetic
    assign {Co, y} = a + b + Cin;
endmodule

// 16‐bit adder built from two 8‐bit adders
module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    // intermediate carry between the two 8‑bit blocks
    wire carry_mid;

    // instantiate lower 8‐bit chunk
    adder_8bit u_lower (
        .a   (a[7:0]),
        .b   (b[7:0]),
        .Cin (Cin),
        .y   (y[7:0]),
        .Co  (carry_mid)
    );

    // instantiate upper 8‐bit chunk
    adder_8bit u_upper (
        .a   (a[15:8]),
        .b   (b[15:8]),
        .Cin (carry_mid),
        .y   (y[15:8]),
        .Co  (Co)
    );
endmodule