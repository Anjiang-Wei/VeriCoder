module adder4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire Cin,
    output wire [3:0] y,
    output wire Co
);

    wire c1, c2;

    full_adder fa1 (
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .y(y[0]),
        .Co(c1)
    );

    full_adder fa2 (
        .a(a[1]),
        .b(b[1]),
        .Cin(c1),
        .y(y[1]),
        .Co(c2)
    );

    full_adder fa3 (
        .a(a[2]),
        .b(b[2]),
        .Cin(c2),
        .y(y[2]),
        .Co(c3)
    );

    full_adder fa4 (
        .a(a[3]),
        .b(b[3]),
        .Cin(c3),
        .y(y[3]),
        .Co(Co)
    );

endmodule