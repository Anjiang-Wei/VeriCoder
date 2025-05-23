`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;

   reg [15:0] multiplicand, multiplier;
   reg [4:0] ctr;  // 5-bit counter to keep track of process steps

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // Initialize registers
         multiplicand <= {{8{a[7]}}, a};  // Sign-extend a
         multiplier <= {{8{b[7]}}, b};     // Sign-extend b
         p <= 16'b0;                       // Initialize product to 0
         ctr <= 5'b0;                      // Reset counter
         rdy <= 1'b0;                      // Set ready signal to 0
      end else if (ctr < 16) begin
         // Radix-4 Booth algorithm operations
         if (multiplier[ctr[4:1] + 1:ctr[4:1]] == 2'b01) begin
            p <= p + multiplicand;  // Add multiplicand if current Booth encoding is 01
         end else if (multiplier[ctr[4:1] + 1:ctr[4:1]] == 2'b10) begin
            p <= p - multiplicand;  // Subtract multiplicand if current Booth encoding is 10
         end
         
         // Shift multiplicand left for next iteration
         multiplicand <= multiplicand << 1;
         
         // Increment counter
         ctr <= ctr + 1;
      end
      
      // Check for completion and set ready signal
      if (ctr == 16) begin
         rdy <= 1'b1;  // Set ready signal to 1 to indicate multiplication is complete
      end
   end
endmodule