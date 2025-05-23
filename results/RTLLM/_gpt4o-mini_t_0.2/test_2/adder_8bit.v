module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout
);
    
    wire [7:0] carry; // Intermediate carry wires for each bit

    // Full adder logic for each bit position
    assign sum[0] = a[0] ^ b[0] ^ cin;          // Sum for the least significant bit
    assign carry[0] = (a[0] & b[0]) | (cin & (a[0] ^ b[0])); // Carry for the least significant bit

    assign sum[1] = a[1] ^ b[1] ^ carry[0];     // Sum for bit 1
    assign carry[1] = (a[1] & b[1]) | (carry[0] & (a[1] ^ b[1])); // Carry for bit 1

    assign sum[2] = a[2] ^ b[2] ^ carry[1];     // Sum for bit 2
    assign carry[2] = (a[2] & b[2]) | (carry[1] & (a[2] ^ b[2])); // Carry for bit 2

    assign sum[3] = a[3] ^ b[3] ^ carry[2];     // Sum for bit 3
    assign carry[3] = (a[3] & b[3]) | (carry[2] & (a[3] ^ b[3])); // Carry for bit 3

    assign sum[4] = a[4] ^ b[4] ^ carry[3];     // Sum for bit 4
    assign carry[4] = (a[4] & b[4]) | (carry[3] & (a[4] ^ b[4])); // Carry for bit 4

    assign sum[5] = a[5] ^ b[5] ^ carry[4];     // Sum for bit 5
    assign carry[5] = (a[5] & b[5]) | (carry[4] & (a[5] ^ b[5])); // Carry for bit 5

    assign sum[6] = a[6] ^ b[6] ^ carry[5];     // Sum for bit 6
    assign carry[6] = (a[6] & b[6]) | (carry[5] & (a[6] ^ b[6])); // Carry for bit 6

    assign sum[7] = a[7] ^ b[7] ^ carry[6];     // Sum for bit 7
    assign cout = (a[7] & b[7]) | (carry[6] & (a[7] ^ b[7])); // Carry-out for the most significant bit

endmodule