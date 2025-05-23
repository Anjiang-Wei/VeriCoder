module adder_16bit (
    input wire [15:0] a,     // 16-bit input operand A
    input wire [15:0] b,     // 16-bit input operand B
    input wire Cin,          // Carry-in input
    output wire [15:0] y,    // 16-bit output representing the sum of A and B
    output wire Co           // Carry-out output
);

// Instance of 8-bit adder module
adder_8bit adder1 (
    .a(a[7:0]),         // Lower 8 bits of input operand A
    .b(b[7:0]),         // Lower 8 bits of input operand B
    .Cin(Cin),           // Carry-in input for the lower 8-bit adder
    .y(y[7:0]),          // Lower 8 bits of output representing the sum of A and B
    .Co(co1)             // Carry-out output for the lower 8-bit adder
);

// Instance of 8-bit adder module
adder_8bit adder2 (
    .a(a[15:8]),        // Upper 8 bits of input operand A
    .b(b[15:8]),        // Upper 8 bits of input operand B
    .Cin(co1),           // Carry-in input for the upper 8-bit adder (from lower 8-bit adder)
    .y(y[15:8]),         // Upper 8 bits of output representing the sum of A and B
    .Co(co2)             // Carry-out output for the upper 8-bit adder
);

// Instance of 1-bit full adder module to get final carry out (Co)
adder_1bit adder_final (
    .a(co1),          // Carry-in input from lower 8-bit adder
    .b(co2),          // Carry-in input from upper 8-bit adder
    .Cin(Cin),        // Original carry-in input
    .y(y[15]),        // MSB of output representing the sum of A and B
    .Co(Co)           // Final carry-out output
);

endmodule