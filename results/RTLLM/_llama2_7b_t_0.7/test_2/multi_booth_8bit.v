`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   // Registers for multiplier and multiplicand
   reg [8:0] multiplier, multiplicand;

   // Counter for Booth algorithm
   reg [5:0] ctr;

   // Ready signal for completion of multiplication
   output rdy;

   // Initialize registers and counter
   always @*posedge clk or @*posedge reset begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         ctr <= 0;
      end else begin
         // Check if counter is less than 16
         if (ctr < 16) begin
            // Shift multiplicand register by 1 bit
            multiplicand <= {multiplicand[7], multiplicand[6..0]};
            // Check current bit of multiplier register
            if (multiplier[ctr]) begin
               // Accumulate product of multiplicand and multiplier
               p <= p + multiplicand;
               // Increment counter
               ctr <= ctr + 1;
            end else begin
               // Reset product register and increment counter
               p <= 0;
               ctr <= ctr + 1;
            end
         end else begin
            // Set ready signal to indicate completion of multiplication
            rdy <= 1;
         end
      end
   end
endmodule