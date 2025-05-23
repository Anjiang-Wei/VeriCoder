module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    // Define internal wires for the 8-bit adders
    wire [7:0] sum_low, sum_high;
    wire carry_low, carry_high;

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(carry_low)
    );

    // Instantiate the 8-bit adder for the higher 8 bits
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_low),
        .y(sum_high),
        .Co(carry_high)
    );

    // Combine the results from the two 8-bit adders
    assign y = {sum_high, sum_low};
    assign Co = carry_high;

endmodule

// Define the 8-bit full adder module
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    wire [7:0] carry;

    // Full adder for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .Cin((i == 0) ? Cin : carry[i-1]),
                .sum(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate

    // The final carry out is the carry from the last bit
    assign Co = carry[7];

endmodule

// Define the full adder module
module full_adder (
    input wire a,
    input wire b,
    input wire Cin,
    output wire sum,
    output wire Co
);
    // Sum is the XOR of the three inputs
    assign sum = a ^ b ^ Cin;
    // Carry out is the OR of the ANDs of the inputs
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule