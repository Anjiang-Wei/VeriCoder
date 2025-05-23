module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout
);
    // Internal signals for carry between full adders
    wire [7:0] carry;

    // Full adder for bit 0
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Full adder for bit 1
    full_adder fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    // Full adder for bit 2
    full_adder fa2 (
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    // Full adder for bit 3
    full_adder fa3 (
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(carry[3])
    );

    // Full adder for bit 4
    full_adder fa4 (
        .a(a[4]),
        .b(b[4]),
        .cin(carry[3]),
        .sum(sum[4]),
        .cout(carry[4])
    );

    // Full adder for bit 5
    full_adder fa5 (
        .a(a[5]),
        .b(b[5]),
        .cin(carry[4]),
        .sum(sum[5]),
        .cout(carry[5])
    );

    // Full adder for bit 6
    full_adder fa6 (
        .a(a[6]),
        .b(b[6]),
        .cin(carry[5]),
        .sum(sum[6]),
        .cout(carry[6])
    );

    // Full adder for bit 7
    full_adder fa7 (
        .a(a[7]),
        .b(b[7]),
        .cin(carry[6]),
        .sum(sum[7]),
        .cout(cout) // Final carry-out
    );

endmodule

// Full Adder module
module full_adder(
    input a, b, cin,
    output sum, cout
);
    assign sum = a ^ b ^ cin;       // XOR gate for sum
    assign cout = (a & b) | (b & cin) | (a & cin);  // Carry-out logic
endmodule