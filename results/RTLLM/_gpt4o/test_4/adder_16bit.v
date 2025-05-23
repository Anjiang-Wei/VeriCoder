// Verilog implementation of a 16-bit full adder using 8-bit adder instances.

module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire carry_out_1; // Intermediate carry between the first and second 8-bit adders

    // First 8-bit adder for lower 8 bits
    adder_8bit u_adder_8bit_1 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_out_1)
    );

    // Second 8-bit adder for upper 8 bits
    adder_8bit u_adder_8bit_2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_out_1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule

// Submodule: 8-bit full adder
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

    wire [8:0] sum; // Use a 9-bit wire for internal sum including carry
    assign sum = a + b + Cin;

    assign y = sum[7:0]; // Least significant 8 bits are the sum output
    assign Co = sum[8];  // Most significant bit is the carry-out

endmodule