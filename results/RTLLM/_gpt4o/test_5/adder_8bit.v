module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout
);
    wire [7:0] carry; // Internal carries between the full adders

    // Instantiate 8 full adders for each bit of the 8-bit addition
    // Full adder for bit 0
    assign {carry[0], sum[0]} = a[0] + b[0] + cin;

    // Full adder for bit 1
    assign {carry[1], sum[1]} = a[1] + b[1] + carry[0];

    // Full adder for bit 2
    assign {carry[2], sum[2]} = a[2] + b[2] + carry[1];

    // Full adder for bit 3
    assign {carry[3], sum[3]} = a[3] + b[3] + carry[2];

    // Full adder for bit 4
    assign {carry[4], sum[4]} = a[4] + b[4] + carry[3];

    // Full adder for bit 5
    assign {carry[5], sum[5]} = a[5] + b[5] + carry[4];

    // Full adder for bit 6
    assign {carry[6], sum[6]} = a[6] + b[6] + carry[5];

    // Full adder for bit 7
    assign {cout, sum[7]} = a[7] + b[7] + carry[6];

endmodule