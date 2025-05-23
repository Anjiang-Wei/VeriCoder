module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

    wire [7:0] s;
    wire c1, c2, c3, c4, c5, c6;
    
    full_adder fa0(a[0], b[0], cin, s[0], c1);
    full_adder fa1(a[1], b[1], c1, s[1], c2);
    full_adder fa2(a[2], b[2], c2, s[2], c3);
    full_adder fa3(a[3], b[3], c3, s[3], c4);
    full_adder fa4(a[4], b[4], c4, s[4], c5);
    full_adder fa5(a[5], b[5], c5, s[5], c6);
    full_adder fa6(a[6], b[6], c6, s[6], cout);
    full_adder fa7(a[7], b[7], cout, s[7], sum[7]);
    
    assign sum = s;
    
endmodule