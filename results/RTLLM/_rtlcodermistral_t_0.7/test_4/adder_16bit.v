// Implement another 8-bit adder
    wire [7:0] sum_8bit2;
    wire carry_8bit2;
    eight_bit_adder adder_8bit2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_8bit),
        .y(sum_8bit2),
        .Co(carry_8bit2)
    );