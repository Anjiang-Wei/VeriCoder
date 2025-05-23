module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

// Define the number of 8-bit adders required for 16-bit addition
localparam NUM_ADDERS = 2;

// Instantiate 8-bit adders with Carry-in and Carry-out ports
adder_8bit #(.WIDTH(8)) adder1 (
    .a({a[15], a[7:0]}),
    .b({b[15], b[7:0]}),
    .Cin(Cin),
    .y({y[15:8], Co}),
    .Co()
);

adder_8bit #(.WIDTH(8)) adder2 (
    .a({a[7:0], a[3:0]}),
    .b({b[7:0], b[3:0]}),
    .Cin(y[15]),
    .y({y[7:4], Co}),
    .Co()
);

adder_8bit #(.WIDTH(4)) adder3 (
    .a(a[3:0]),
    .b(b[3:0]),
    .Cin(Co),
    .y(y[3:0]),
    .Co(Co)
);
endmodule

// Define a smaller 8-bit full adder module
module adder_8bit #(
    parameter WIDTH = 8
) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire Cin,
    output wire [WIDTH-1:0] y,
    output wire Co
);

// Calculate the sum of A and B
assign y = a + b;

// Calculate the Carry-out (Co)
assign Co = (a[WIDTH-1] & b[WIDTH-1]) | (a[WIDTH-1] & Cin) | (b[WIDTH-1] & Cin);
endmodule