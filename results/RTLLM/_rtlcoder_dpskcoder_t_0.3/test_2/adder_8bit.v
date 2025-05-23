module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);
    
    wire [7:0] c;
    wire [7:0] s;
    
    // First bit-level adder
    full_adder fa0(a[0], b[0], cin, s[0], c[0]);
    
    // Second bit-level adder
    full_adder fa1(a[1], b[1], c[0], s[1], c[1]);
    
    // Third bit-level adder
    full_adder fa2(a[2], b[2], c[1], s[2], c[2]);
    
    // Fourth bit-level adder
    full_adder fa3(a[3], b[3], c[2], s[3], c[3]);
    
    // Fifth bit-level adder
    full_adder fa4(a[4], b[4], c[3], s[4], c[4]);
    
    // Sixth bit-level adder
    full_adder fa5(a[5], b[5], c[4], s[5], c[5]);
    
    // Seventh bit-level adder
    full_adder fa6(a[6], b[6], c[5], s[6], c[6]);
    
    // Eighth bit-level adder
    full_adder fa7(a[7], b[7], c[6], s[7], cout);
    
    assign sum = s;
    
endmodule