module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    // Define the 8-bit full adder module
    module adder_8bit (
        input wire [7:0] a,
        input wire [7:0] b,
        input wire Cin,
        output wire [7:0] y,
        output wire Co
    );
        assign {Co, y} = a + b + Cin;
    endmodule

    // Instantiate two 8-bit adders
    wire [7:0] sum_lo, sum_hi;
    wire Co_lo, Co_hi;

    adder_8bit adder_lo (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_lo),
        .Co(Co_lo)
    );

    adder_8bit adder_hi (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_lo),
        .y(sum_hi),
        .Co(Co_hi)
    );

    // Assign the final sum and carry out
    assign y = {sum_hi, sum_lo};
    assign Co = Co_hi;

endmodule