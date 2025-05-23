module adder_8bit(
    input  [7:0] a, b,    // 8-bit input operands
    input        cin,     // Carry-in input
    output [7:0] sum,     // 8-bit sum output
    output       cout     // Carry-out output
);

  // Internal wires to connect the carry-out of one full adder to the carry-in of the next
  wire c0, c1, c2, c3, c4, c5, c6;

  // Instantiate 8 full adders for each bit
  full_adder FA0 (
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .cout(c0)
  );

  full_adder FA1 (
    .a(a[1]),
    .b(b[1]),
    .cin(c0),
    .sum(sum[1]),
    .cout(c1)
  );

  full_adder FA2 (
    .a(a[2]),
    .b(b[2]),
    .cin(c1),
    .sum(sum[2]),
    .cout(c2)
  );

  full_adder FA3 (
    .a(a[3]),
    .b(b[3]),
    .cin(c2),
    .sum(sum[3]),
    .cout(c3)
  );

  full_adder FA4 (
    .a(a[4]),
    .b(b[4]),
    .cin(c3),
    .sum(sum[4]),
    .cout(c4)
  );

  full_adder FA5 (
    .a(a[5]),
    .b(b[5]),
    .cin(c4),
    .sum(sum[5]),
    .cout(c5)
  );

  full_adder FA6 (
    .a(a[6]),
    .b(b[6]),
    .cin(c5),
    .sum(sum[6]),
    .cout(c6)
  );

  full_adder FA7 (
    .a(a[7]),
    .b(b[7]),
    .cin(c6),
    .sum(sum[7]),
    .cout(cout)
  );

endmodule