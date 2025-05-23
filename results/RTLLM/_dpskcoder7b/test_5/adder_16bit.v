module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

// Instantiate a 4-bit adder
adder_4bit adder_inst (
    .a(a[3:0]),
    .b(b[3:0]),
    .Cin(Cin),
    .y(y[3:0]),
    .Co(sum_temp[0])
);

// Instantiate another 4-bit adder
adder_4bit adder_inst_1 (
    .a(a[7:4]),
    .b(b[7:4]),
    .Cin(sum_temp[0]),
    .y(y[7:4]),
    .Co(sum_temp[1])
);

// Instantiate another 4-bit adder
adder_4bit adder_inst_2 (
    .a(a[11:8]),
    .b(b[11:8]),
    .Cin(sum_temp[1]),
    .y(y[11:8]),
    .Co(sum_temp[2])
);

// Instantiate the final 4-bit adder
adder_4bit adder_inst_3 (
    .a(a[15:12]),
    .b(b[15:12]),
    .Cin(sum_temp[2]),
    .y(y[15:12]),
    .Co(Co)
);

endmodule