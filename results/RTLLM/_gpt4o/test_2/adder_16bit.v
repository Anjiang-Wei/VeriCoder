// 8-bit adder module
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    assign {Co, y} = a + b + Cin; // Perform 8-bit addition with carry-in
endmodule

// 16-bit adder module that uses two 8-bit adders
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire Co_lower; // Carry out of the lower 8 bits

    // Instantiate the lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co_lower)
    );

    // Instantiate the upper 8-bit adder
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_lower), // Connect the carry-out of the lower 8-bit adder to the carry-in of the upper 8-bit adder
        .y(y[15:8]),
        .Co(Co)
    );
endmodule