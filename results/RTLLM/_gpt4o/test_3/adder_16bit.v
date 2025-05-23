module adder_16bit (
    input wire [15:0] a,       // 16-bit input operand A
    input wire [15:0] b,       // 16-bit input operand B
    input wire Cin,            // Carry-in input
    output wire [15:0] y,      // 16-bit result (sum)
    output wire Co             // Carry-out
);

    wire carry_intermediate;   // Carry-out from the lower 8 bits

    // Instantiate 8-bit adder for lower bits [7:0]
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_intermediate)
    );

    // Instantiate 8-bit adder for upper bits [15:8]
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_intermediate),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule


// 8-bit adder module definition
module adder_8bit (
    input wire [7:0] a,        // 8-bit input operand A
    input wire [7:0] b,        // 8-bit input operand B
    input wire Cin,            // Carry-in input
    output wire [7:0] y,       // 8-bit result (sum)
    output wire Co             // Carry-out
);

    assign {Co, y} = a + b + Cin;  // Perform addition with carry-in

endmodule