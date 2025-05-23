module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

    wire [7:0] c;
    wire [7:0] s;

    // Full adder 0
    full_adder fa0(a[0], b[0], cin, s[0], c[0]);

    // Full adder 1
    full_adder fa1(a[1], b[1], c[0], s[1], c[1]);

    // Full adder 2
    full_adder fa2(a[2], b[2], c[1], s[2], c[2]);

    // Full adder 3
    full_adder fa3(a[3], b[3], c[2], s[3], c[3]);

    // Full adder 4
    full_adder fa4(a[4], b[4], c[3], s[4], c[4]);

    // Full adder 5
    full_adder fa5(a[5], b[5], c[4], s[5], c[5]);

    // Full adder 6
    full_adder fa6(a[6], b[6], c[5], s[6], c[6]);

    // Full adder 7
    full_adder fa7(a[7], b[7], c[6], s[7], cout);

    assign sum = s;

endmodule