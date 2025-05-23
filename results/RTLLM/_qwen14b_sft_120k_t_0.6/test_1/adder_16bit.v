module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    // 8-bit adder module
    module adder_8bit (
        input wire [7:0] a,
        input wire [7:0] b,
        input wire Cin,
        output wire [7:0] sum,
        output wire Co
    );
        assign {Co, sum} = a + b + Cin;
    endmodule

    // Instantiate 8-bit adders for each 8-bit segment
    wire [7:0] sum_0, sum_1;
    wire Co_0, Co_1;

    adder_8bit adder_0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(sum_0),
        .Co(Co_0)
    );

    adder_8bit adder_1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_0),
        .sum(sum_1),
        .Co(Co_1)
    );

    // Assign the outputs
    assign y = {sum_1, sum_0};
    assign Co = Co_1;

endmodule