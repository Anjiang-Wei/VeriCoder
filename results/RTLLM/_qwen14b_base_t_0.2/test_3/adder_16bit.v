module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    wire [7:0] carry;
    
    // Instantiate 8 full adders
    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin), .sum(y[0]), .Cout(carry[0]));
    full_adder fa1 (.a(a[1]), .b(b[1]), .Cin(carry[0]), .sum(y[1]), .Cout(carry[1]));
    full_adder fa2 (.a(a[2]), .b(b[2]), .Cin(carry[1]), .sum(y[2]), .Cout(carry[2]));
    full_adder fa3 (.a(a[3]), .b(b[3]), .Cin(carry[2]), .sum(y[3]), .Cout(carry[3]));
    full_adder fa4 (.a(a[4]), .b(b[4]), .Cin(carry[3]), .sum(y[4]), .Cout(carry[4]));
    full_adder fa5 (.a(a[5]), .b(b[5]), .Cin(carry[4]), .sum(y[5]), .Cout(carry[5]));
    full_adder fa6 (.a(a[6]), .b(b[6]), .Cin(carry[5]), .sum(y[6]), .Cout(carry[6]));
    full_adder fa7 (.a(a[7]), .b(b[7]), .Cin(carry[6]), .sum(y[7]), .Cout(carry[7]));
    
    // Assign the carry out of the last full adder to the output Co
    assign Co = carry[7];
endmodule