module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [3:0] carry;

    // Instantiate four 8-bit adders
    adder_8bit adder0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry[0])
    );

    adder_8bit adder1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry[0]),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule