module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

    wire [7:0] carry;
    wire [7:0] sum_partial;

    // Full adder at bit 0
    full_adder fa0(a[0], b[0], cin, sum_partial[0], carry[0]);

    // Full adder at bit 1
    full_adder fa1(a[1], b[1], carry[0], sum_partial[1], carry[1]);

    // Full adder at bit 2
    full_adder fa2(a[2], b[2], carry[1], sum_partial[2], carry[2]);

    // Full adder at bit 3
    full_adder fa3(a[3], b[3], carry[2], sum_partial[3], carry[3]);

    // Full adder at bit 4
    full_adder fa4(a[4], b[4], carry[3], sum_partial[4], carry[4]);

    // Full adder at bit 5
    full_adder fa5(a[5], b[5], carry[4], sum_partial[5], carry[5]);

    // Full adder at bit 6
    full_adder fa6(a[6], b[6], carry[5], sum_partial[6], carry[6]);

    // Full adder at bit 7
    full_adder fa7(a[7], b[7], carry[6], sum_partial[7], cout);

    assign sum = sum_partial;

endmodule