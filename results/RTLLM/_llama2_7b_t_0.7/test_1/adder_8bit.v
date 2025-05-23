module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

  // Implementation of multiple bit-level adders
  always @* begin
    case (a) // Handle each bit of A
     0: sum = b;
     1: sum = a + b;
     2: sum = a & b;
     3: sum = a | b;
     4: sum = a ^ b;
     5: sum = a != b;
     6: sum = a > b;
     7: sum = a < b;
    endcase // End of case statement
  end // Always block

  // Output the carry-in input
  cout = cin;

endmodule // End of module definition