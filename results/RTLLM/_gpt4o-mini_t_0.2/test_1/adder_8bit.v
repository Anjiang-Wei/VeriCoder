module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout
);
    wire [7:0] carry; // Intermediate carry wires

    // Full Adder for bit 0
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (cin & (a[0] ^ b[0]));

    // Full Adder for bit 1
    assign sum[1] = a[1] ^ b[1] ^ carry[0];
    assign carry[1] = (a[1] & b[1]) | (carry[0] & (a[1] ^ b[1]));

    // Full Adder for bit 2
    assign sum[2] = a[2] ^ b[2] ^ carry[1];
    assign carry[2] = (a[2] & b[2]) | (carry[1] & (a[2] ^ b[2]));

    // Full Adder for bit 3
    assign sum[3] = a[3] ^ b[3] ^ carry[2];
    assign carry[3] = (a[3] & b[3]) | (carry[2] & (a[3] ^ b[3]));

    // Full Adder for bit 4
    assign sum[4] = a[4] ^ b[4] ^ carry[3];
    assign carry[4] = (a[4] & b[4]) | (carry[3] & (a[4] ^ b[4]));

    // Full Adder for bit 5
    assign sum[5] = a[5] ^ b[5] ^ carry[4];
    assign carry[5] = (a[5] & b[5]) | (carry[4] & (a[5] ^ b[5]));

    // Full Adder for bit 6
    assign sum[6] = a[6] ^ b[6] ^ carry[5];
    assign carry[6] = (a[6] & b[6]) | (carry[5] & (a[6] ^ b[6]));

    // Full Adder for bit 7
    assign sum[7] = a[7] ^ b[7] ^ carry[6];
    assign carry[7] = (a[7] & b[7]) | (carry[6] & (a[7] ^ b[7]));

    // Carry-out is the last carry
    assign cout = carry[7];

endmodule