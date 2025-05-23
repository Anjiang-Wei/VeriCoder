module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

// Define an 8-bit full adder module
module full_adder (
    input wire a,
    input wire b,
    input wire Cin,
    output wire sum,
    output wire Cout
);

    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (b & Cin) | (a & Cin);
endmodule

// Instantiate 2 instances of the 8-bit full adder module in parallel
full_adder fa1 (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(Cin),
    .sum(y[7:0]),
    .Cout(Co_1)
);

full_adder fa2 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(Co_1),
    .sum(y[15:8]),
    .Cout(Co)
);

// Use the carry-out from the first 8-bit adder to feed into the second 8-bit adder
assign Co = Co;

endmodule // end of module adder_16bit