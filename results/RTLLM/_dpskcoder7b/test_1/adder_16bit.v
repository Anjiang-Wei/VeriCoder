module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    wire [14:0] carry;

    // Instantiate 8-bit adder
    full_adder_8bit u0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry[0])
    );

    // Instantiate 8-bit adder
    full_adder_8bit u1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry[0]),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule

// 8-bit full adder module
module full_adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

    wire [6:0] carry;

    // Instantiate 4-bit adder
    full_adder_4bit u0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry[0])
    );

    // Instantiate 4-bit adder
    full_adder_4bit u1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry[0]),
        .y(y[7:4]),
        .Co(carry[1])
    );

    // Generate carry out
    assign Co = carry[1];

endmodule

// 4-bit full adder module
module full_adder_4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire Cin,
    output wire [3:0] y,
    output wire Co
);

    wire [2:0] carry;

    // Instantiate 2-bit adder
    full_adder_2bit u0 (
        .a(a[1:0]),
        .b(b[1:0]),
        .Cin(Cin),
        .y(y[1:0]),
        .Co(carry[0])
    );

    // Instantiate 2-bit adder
    full_adder_2bit u1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .Cin(carry[0]),
        .y(y[3:2]),
        .Co(carry[1])
    );

    // Generate carry out
    assign Co = carry[1];

endmodule

// 2-bit full adder module
module full_adder_2bit (
    input wire [1:0] a,
    input wire [1:0] b,
    input wire Cin,
    output wire [1:0] y,
    output wire Co
);

    // Generate sum
    assign y = a + b + Cin;

    // Generate carry out
    assign Co = (a[1] & b[1]) | (a[1] & Cin) | (b[1] & Cin);

endmodule