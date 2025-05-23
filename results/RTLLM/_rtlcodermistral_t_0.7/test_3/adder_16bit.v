module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

wire [7:0] sum_1;
wire [7:0] sum_2;
wire [7:0] sum_3;
wire [7:0] sum_4;
wire [7:0] sum_5;
wire [7:0] sum_6;
wire [7:0] sum_7;
wire [7:0] sum_8;
wire [7:0] sum_9;
wire [7:0] sum_10;
wire [7:0] sum_11;
wire [7:0] sum_12;
wire [7:0] sum_13;
wire [7:0] sum_14;
wire [7:0] sum_15;
wire [7:0] sum_16;

// Instantiate 8-bit adders
adder_8bit adder_1 (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(Cin),
    .y(sum_1),
    .Co()
);

adder_8bit adder_2 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(sum_1[7]),
    .y(sum_2),
    .Co()
);

adder_8bit adder_3 (
    .a(sum_1),
    .b(sum_2),
    .Cin(sum_10[7]),
    .y(sum_3),
    .Co()
);

adder_8bit adder_4 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(sum_1[7]),
    .y(sum_4),
    .Co()
);

adder_8bit adder_5 (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(sum_1[7]),
    .y(sum_5),
    .Co()
);

adder_8bit adder_6 (
    .a(sum_1),
    .b(sum_2),
    .Cin(sum_10[7]),
    .y(sum_6),
    .Co()
);

adder_8bit adder_7 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(sum_1[7]),
    .y(sum_7),
    .Co()
);

adder_8bit adder_8 (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(sum_1[7]),
    .y(sum_8),
    .Co()
);

adder_8bit adder_9 (
    .a(sum_1),
    .b(sum_2),
    .Cin(sum_10[7]),
    .y(sum_9),
    .Co()
);

adder_8bit adder_10 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(sum_1[7]),
    .y(sum_10),
    .Co()
);

adder_8bit adder_11 (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(sum_1[7]),
    .y(sum_11),
    .Co()
);

adder_8bit adder_12 (
    .a(sum_1),
    .b(sum_2),
    .Cin(sum_10[7]),
    .y(sum_12),
    .Co()
);

adder_8bit adder_13 (
    .a(a[15:8]),