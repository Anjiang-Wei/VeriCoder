module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

    // Declare internal signals for carry bits
    wire c1, c2, c3, c4, c5, c6, c7;

    // Instantiate full adders for each bit
    full_adder fa0 (a[0], b[0], cin, sum[0], c1);
    full_adder fa1 (a[1], b[1], c1, sum[1], c2);
    full_adder fa2 (a[2], b[2], c2, sum[2], c3);
    full_adder fa3 (a[3], b[3], c3, sum[3], c4);
    full_adder fa4 (a[4], b[4], c4, sum[4], c5);
    full_adder fa5 (a[5], b[5], c5, sum[5], c6);
    full_adder fa6 (a[6], b[6], c6, sum[6], c7);
    full_adder fa7 (a[7], b[7], c7, sum[7], cout);

endmodule