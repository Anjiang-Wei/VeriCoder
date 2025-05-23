// 8-bit adder module
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] sum,
    output wire Co
);
    assign {Co, sum} = a + b + Cin; // Perform addition with carry-in
endmodule

// 16-bit adder module
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    // Intermediate carry signals
    wire carry_out_lower;
    
    // Instantiate the lower (LSB) 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Co(carry_out_lower)
    );

    // Instantiate the upper (MSB) 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_out_lower),
        .sum(y[15:8]),
        .Co(Co)
    );
endmodule