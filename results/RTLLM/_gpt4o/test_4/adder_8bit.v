module adder_8bit(
    input [7:0] a, 
    input [7:0] b, 
    input cin, 
    output [7:0] sum, 
    output cout
);
    // Internal carry signals
    wire [7:0] carry;

    // First bit full adder (LSB)
    assign sum[0] = a[0] ^ b[0] ^ cin;       // Sum for the first bit
    assign carry[0] = (a[0] & b[0]) | (cin & (a[0] ^ b[0])); // Carry out for first bit

    // 2nd bit full adder
    assign sum[1] = a[1] ^ b[1] ^ carry[0];
    assign carry[1] = (a[1] & b[1]) | (carry[0] & (a[1] ^ b[1]));

    // 3rd bit full adder
    assign sum[2] = a[2] ^ b[2] ^ carry[1];
    assign carry[2] = (a[2] & b[2]) | (carry[1] & (a[2] ^ b[2]));

    // 4th bit full adder
    assign sum[3] = a[3] ^ b[3] ^ carry[2];
    assign carry[3] = (a[3] & b[3]) | (carry[2] & (a[3] ^ b[3]));

    // 5th bit full adder
    assign sum[4] = a[4] ^ b[4] ^ carry[3];
    assign carry[4] = (a[4] & b[4]) | (carry[3] & (a[4] ^ b[4]));

    // 6th bit full adder
    assign sum[5] = a[5] ^ b[5] ^ carry[4];
    assign carry[5] = (a[5] & b[5]) | (carry[4] & (a[5] ^ b[5]));

    // 7th bit full adder
    assign sum[6] = a[6] ^ b[6] ^ carry[5];
    assign carry[6] = (a[6] & b[6]) | (carry[5] & (a[6] ^ b[6]));

    // 8th bit full adder (MSB)
    assign sum[7] = a[7] ^ b[7] ^ carry[6];
    assign carry[7] = (a[7] & b[7]) | (carry[6] & (a[7] ^ b[7]));

    // Final carry-out
    assign cout = carry[7];
endmodule