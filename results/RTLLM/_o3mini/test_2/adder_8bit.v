module adder_8bit(
    input  [7:0] a,    // 8-bit operand A
    input  [7:0] b,    // 8-bit operand B
    input        cin,  // Carry-in
    output [7:0] sum,  // 8-bit sum output
    output       cout  // Carry-out
);
    // Internal wires to chain the carry signals for each bit-level addition
    wire [7:0] carry;

    // Bit 0 addition: uses cin as the first carry in.
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Bit 1 addition: uses carry from bit 0.
    full_adder fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    // Bit 2 addition.
    full_adder fa2 (
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    // Bit 3 addition.
    full_adder fa3 (
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(carry[3])
    );

    // Bit 4 addition.
    full_adder fa4 (
        .a(a[4]),
        .b(b[4]),
        .cin(carry[3]),
        .sum(sum[4]),
        .cout(carry[4])
    );

    // Bit 5 addition.
    full_adder fa5 (
        .a(a[5]),
        .b(b[5]),
        .cin(carry[4]),
        .sum(sum[5]),
        .cout(carry[5])
    );

    // Bit 6 addition.
    full_adder fa6 (
        .a(a[6]),
        .b(b[6]),
        .cin(carry[5]),
        .sum(sum[6]),
        .cout(carry[6])
    );

    // Bit 7 addition: final bit.
    full_adder fa7 (
        .a(a[7]),
        .b(b[7]),
        .cin(carry[6]),
        .sum(sum[7]),
        .cout(cout)  // The final carry-out is the module's cout.
    );

endmodule