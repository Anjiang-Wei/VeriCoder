module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    wire [7:0] sum;
    wire [7:0] carry;

    // Generate the sum and carry for each bit
    assign {Co, sum} = a + b + Cin;

    // Assign output
    assign y = sum;

endmodule

module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire Co1; // Carry from the first 8-bit adder

    // Instantiate two 8-bit adders
    adder_8bit adder1 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co1)
    );

    adder_8bit adder2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule