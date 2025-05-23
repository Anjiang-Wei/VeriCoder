module adder_8bit(
    input [7:0] a,    // 8-bit input operand A
    input [7:0] b,    // 8-bit input operand B
    input cin,        // Carry-in input
    output [7:0] sum, // 8-bit sum output
    output cout       // Carry-out output
);
    // Internal wires to connect the carry between full adders
    wire [6:0] carry;

    // Bit-level full adder for bit 0
    full_adder FA0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Bit-level full adder for bit 1
    full_adder FA1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    // Bit-level full adder for bit 2
    full_adder FA2 (
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    // Bit-level full adder for bit 3
    full_adder FA3 (
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(carry[3])
    );

    // Bit-level full adder for bit 4
    full_adder FA4 (
        .a(a[4]),
        .b(b[4]),
        .cin(carry[3]),
        .sum(sum[4]),
        .cout(carry[4])
    );

    // Bit-level full adder for bit 5
    full_adder FA5 (
        .a(a[5]),
        .b(b[5]),
        .cin(carry[4]),
        .sum(sum[5]),
        .cout(carry[5])
    );

    // Bit-level full adder for bit 6
    full_adder FA6 (
        .a(a[6]),
        .b(b[6]),
        .cin(carry[5]),
        .sum(sum[6]),
        .cout(carry[6])
    );

    // Bit-level full adder for bit 7 (most significant bit)
    full_adder FA7 (
        .a(a[7]),
        .b(b[7]),
        .cin(carry[6]),
        .sum(sum[7]),
        .cout(cout)
    );
endmodule