module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [7:0] sum_low;   // Sum of the lower 8 bits
    wire [7:0] sum_high;  // Sum of the upper 8 bits
    wire carry_low;       // Carry from the lower 8 bits

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit adder0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(carry_low)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit adder1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_low), // Take carry from the lower adder
        .y(sum_high),
        .Co(Co)          // Carry-out for the full 16-bit adder
    );

    // Concatenate the results from both 8-bit adders
    assign y = {sum_high, sum_low};

endmodule

// 8-bit adder module definition
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    assign {Co, y} = a + b + Cin; // Simple addition with carry-out
endmodule