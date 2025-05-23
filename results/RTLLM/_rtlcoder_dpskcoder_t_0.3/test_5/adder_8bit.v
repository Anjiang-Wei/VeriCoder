module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);
    
    wire [7:0] c;
    assign c[0] = cin;
    
    full_adder fa0(a[0], b[0], c[0], sum[0], c[1]);
    full_adder fa1(a[1], b[1], c[1], sum[1], c[2]);
    full_adder fa2(a[2], b[2], c[2], sum[2], c[3]);
    full_adder fa3(a[3], b[3], c[3], sum[3], c[4]);
    full_adder fa4(a[4], b[4], c[4], sum[4], c[5]);
    full_adder fa5(a[5], b[5], c[5], sum[5], c[6]);
    full_adder fa6(a[6], b[6], c[6], sum[6], c[7]);
    full_adder fa7(a[7], b[7], c[7], sum[7], cout);
    
endmodule