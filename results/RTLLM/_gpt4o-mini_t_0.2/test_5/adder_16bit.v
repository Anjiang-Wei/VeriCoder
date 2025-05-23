module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    // Intermediate carry signals
    wire Co1; // Carry out from the first 8-bit adder

    // Instantiate two 8-bit adders
    adder_8bit adder0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co1)
    );

    adder_8bit adder1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule

// 8-bit adder module definition
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    assign {Co, y} = a + b + Cin; // Simple addition with carry
endmodule