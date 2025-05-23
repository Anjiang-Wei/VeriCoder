module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

// Instantiate 8-bit adder module for each bit position
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

// Implement 16-bit addition using 8-bit adders
y = a + b + Cin;
Co = a & b & Cin;
endmodule