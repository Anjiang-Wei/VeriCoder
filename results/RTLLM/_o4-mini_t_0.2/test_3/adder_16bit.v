// 8‑bit ripple‑carry adder: instantiable building block
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] y,
    output wire       Co
);
    // simple combinational implementation using Verilog addition
    assign {Co, y} = a + b + Cin;
endmodule


// 16‑bit adder built from two instances of the 8‑bit adder
module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    // internal carry between the low and high bytes
    wire c_mid;

    // instantiate lower 8‑bit adder
    adder_8bit u_adder_lo (
        .a   (a[7:0]),
        .b   (b[7:0]),
        .Cin (Cin),
        .y   (y[7:0]),
        .Co  (c_mid)
    );

    // instantiate upper 8‑bit adder
    adder_8bit u_adder_hi (
        .a   (a[15:8]),
        .b   (b[15:8]),
        .Cin (c_mid),
        .y   (y[15:8]),
        .Co  (Co)
    );
endmodule