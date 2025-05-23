module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

    // Instantiating the 8-bit full adders
    wire [1:0] c[3:0]; // Carry-out of each bit-level full adder
    
    full_adder fa_0(a[7], b[7], cin, c[0]);
    full_adder fa_1(c[0], a[6], b[6], c[1]);
    full_adder fa_2(c[1], a[5], b[5], c[2]);
    full_adder fa_3(c[2], a[4], b[4], c[3]);

    // Combining the carry-outs to get the final cout
    assign cout = c[3];

    // Calculating the sum
    assign sum[7] = a[7] ^ b[7] ^ cin;
    assign sum[6] = (a[6] ^ b[6]) ^ (c[0] & cin);
    assign sum[5] = (a[5] ^ b[5]) ^ (c[1] & cin);
    assign sum[4] = (a[4] ^ b[4]) ^ (c[2] & cin);
    assign sum[3] = (a[3] ^ b[3]) ^ (c[3]);
    assign sum[2] = (a[2] ^ b[2]) ^ (c[3] & cin);
    assign sum[1] = (a[1] ^ b[1]) ^ (c[3] & cin);
    assign sum[0] = a[0] ^ b[0] ^ c[3];

endmodule

// Full adder module
module full_adder(
    input a, b, cin,
    output s, cout);

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule