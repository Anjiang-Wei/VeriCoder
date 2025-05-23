module adder_8bit(
    input  [7:0] a, 
    input  [7:0] b, 
    input        cin, 
    output [7:0] sum, 
    output       cout
);
    // Intermediate wires to carry the carry-out from each full adder.
    wire [7:0] carry;

    // Bit 0 full adder instance.
    full_adder FA0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Bit 1 full adder instance.
    full_adder FA1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    // Bit 2 full adder instance.
    full_adder FA2 (
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    // Bit 3 full adder instance.
    full_adder FA3 (
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(carry[3])
    );

    // Bit 4 full adder instance.
    full_adder FA4 (
        .a(a[4]),
        .b(b[4]),
        .cin(carry[3]),
        .sum(sum[4]),
        .cout(carry[4])
    );

    // Bit 5 full adder instance.
    full_adder FA5 (
        .a(a[5]),
        .b(b[5]),
        .cin(carry[4]),
        .sum(sum[5]),
        .cout(carry[5])
    );

    // Bit 6 full adder instance.
    full_adder FA6 (
        .a(a[6]),
        .b(b[6]),
        .cin(carry[5]),
        .sum(sum[6]),
        .cout(carry[6])
    );

    // Bit 7 full adder instance.
    full_adder FA7 (
        .a(a[7]),
        .b(b[7]),
        .cin(carry[6]),
        .sum(sum[7]),
        .cout(cout) // The final carry-out is the output cout.
    );

endmodule