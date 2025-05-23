module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [7:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8;
    wire carry1, carry2, carry3, carry4, carry5, carry6, carry7;

    adder_8bit adder1 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum1),
        .Co(carry1)
    );

    adder_8bit adder2 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry1),
        .y(sum2),
        .Co(carry2)
    );

    adder_8bit adder3 (
        .a(sum1),
        .b(sum2),
        .Cin(carry2),
        .y(sum3),
        .Co(carry3)
    );

    adder_8bit adder4 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(carry3),
        .y(sum4),
        .Co(carry4)
    );

    adder_8bit adder5 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry4),
        .y(sum5),
        .Co(carry5)
    );

    adder_8bit adder6 (
        .a(sum4),
        .b(sum5),
        .Cin(carry5),
        .y(sum6),
        .Co(carry6)
    );

    adder_8bit adder7 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(carry6),
        .y(sum7),
        .Co(carry7)
    );

    adder_8bit adder8 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry7),
        .y(sum8),
        .Co(Co)
    );

    assign y = {sum8, sum6, sum3};

endmodule