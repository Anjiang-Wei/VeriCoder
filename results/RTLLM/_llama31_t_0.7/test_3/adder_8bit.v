module adder_8bit(
    input [7:0] a, b,
    input cin,
    output reg [7:0] sum,
    output reg cout);

// Bit-level full adder instances
full_adder fa0(a[7], b[7], cin, sum[7], cout);
full_adder fa1(a[6], b[6], cout, sum[6]);
full_adder fa2(a[5], b[5], cout, sum[5]);
full_adder fa3(a[4], b[4], cout, sum[4]);
full_adder fa4(a[3], b[3], cout, sum[3]);
full_adder fa5(a[2], b[2], cout, sum[2]);
full_adder fa6(a[1], b[1], cout, sum[1]);
full_adder fa7(a[0], b[0], cout, sum[0]);

endmodule