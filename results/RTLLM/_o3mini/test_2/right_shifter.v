module right_shifter(clk, q, d);
  input       clk;
  input       d;
  output reg [7:0] q;
  
  // Initialize q to 0
  initial begin
    q = 8'b00000000;
  end
  
  always @(posedge clk) begin
    // Right-shift the register by 1 bit using the >> operator
    q <= (q >> 1);
    
    // Insert the new input bit (d) in the most significant position
    q[7] <= d;
  end
endmodule