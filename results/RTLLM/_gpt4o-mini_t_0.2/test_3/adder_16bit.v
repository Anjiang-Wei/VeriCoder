module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    assign {Co, y} = a + b + Cin; // Sum with carry generation
endmodule

module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    wire Co1; // Carry-out from the lower 8 bits
    wire [7:0] y0; // Sum from the lower 8 bits
    wire [7:0] y1; // Sum from the upper 8 bits

    // Instantiate the lower 8-bit adder
    adder_8bit adder_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y0),
        .Co(Co1)
    );

    // Instantiate the upper 8-bit adder
    adder_8bit adder_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co1), // Carry-out from the lower adder goes to the upper adder
        .y(y1),
        .Co(Co) // Final carry-out
    );

    assign y = {y1, y0}; // Concatenate results from lower and upper adders

endmodule