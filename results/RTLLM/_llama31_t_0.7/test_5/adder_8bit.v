module adder_8bit(
    input [7:0] a, b, // Input operands A and B
    input cin,        // Carry-in input
    output [7:0] sum, // Output representing the sum of A and B
    output cout        // Carry-out output
);

// Full adder modules for each bit position
wire [7:0] fa0_cout, fa1_cout, fa2_cout, fa3_cout,
           fa4_cout, fa5_cout, fa6_cout;

// Bit-level full adders (FA)
full_adder fa0(a[0], b[0], cin, fa0_cout);
full_adder fa1(fa0_cout, a[1], b[1], fa1_cout);
full_adder fa2(fa1_cout, a[2], b[2], fa2_cout);
full_adder fa3(fa2_cout, a[3], b[3], fa3_cout);

// Carry out for higher bit positions
wire cout_wire = fa6_cout;

// Bit-level full adders for bits 4-7
full_adder fa4(fa3_cout, a[4], b[4], fa4_cout);
full_adder fa5(fa4_cout, a[5], b[5], fa5_cout);
full_adder fa6(fa5_cout, a[6], b[6], fa6_cout);

// Output sum and carry-out
assign sum = {fa7_cout, fa6_cout, fa5_cout, fa4_cout,
              fa3_cout, fa2_cout, fa1_cout, fa0_cout};
assign cout = cout_wire;

endmodule

// Full adder module (bit-level)
module full_adder(
    input a, b, cin, // Inputs A, B and Carry-in
    output cout        // Carry-out for this bit position
);

wire sum_bit;  // Sum of A and B
assign sum_bit = a ^ b;

wire carry_bit;
assign carry_bit = (a & b) | (sum_bit & cin);

// Output the correct value based on whether we're at the last bit or not
assign cout = (|{carry_bit, 1'b0});
endmodule