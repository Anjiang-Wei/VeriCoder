module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

    // Internal signals for carry between full adders
    wire [7:0] carry;

    // Bit 0 Full Adder
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (cin & (a[0] ^ b[0]));

    // Bit 1 Full Adder
    assign sum[1] = a[1] ^ b[1] ^ carry[0];
    assign carry[1] = (a[1] & b[1]) | (carry[0] & (a[1] ^ b[1]));

    // Bit 2 Full Adder
    assign sum[2] = a[2] ^ b[2] ^ carry[1];
    assign carry[2] = (a[2] & b[2]) | (carry[1] & (a[2] ^ b[2]));

    // Bit 3 Full Adder
    assign sum[3] = a[3] ^ b[3] ^ carry[2];
    assign carry[3] = (a[3] & b[3]) | (carry[2] & (a[3] ^ b[3]));

    // Bit 4 Full Adder
    assign sum[4] = a[4] ^ b[4] ^ carry[3];
    assign carry[4] = (a[4] & b[4]) | (carry[3] & (a[4] ^ b[4]));

    // Bit 5 Full Adder
    assign sum[5] = a[5] ^ b[5] ^ carry[4];
    assign carry[5] = (a[5] & b[5]) | (carry[4] & (a[5] ^ b[5]));

    // Bit 6 Full Adder
    assign sum[6] = a[6] ^ b[6] ^ carry[5];
    assign carry[6] = (a[6] & b[6]) | (carry[5] & (a[6] ^ b[6]));

    // Bit 7 Full Adder
    assign sum[7] = a[7] ^ b[7] ^ carry[6];
    assign carry[7] = (a[7] & b[7]) | (carry[6] & (a[7] ^ b[7]));

    // Final Carry-Out
    assign cout = carry[7];

endmodule