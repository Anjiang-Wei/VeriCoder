module adder_16bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

// Small bit-width adder for 8 bits
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

// Implementation of the full adder using the small bit-width adder
adder_16bit (
    .a(a),
    .b(b),
    .Cin(Cin),
    .y(y),
    .Co(Co)
);

endmodule