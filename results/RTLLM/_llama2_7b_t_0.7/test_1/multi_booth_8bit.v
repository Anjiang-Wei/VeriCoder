`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   // Registers for multiplier and multiplicand
   reg [16:0] multiplier, multiplicand;

   // Counter for Booth algorithm
   reg [4:0] ctr;

   // Ready signal for multiplication completion
   reg rdy = 0;

   // Module body
   always @(posedge clk or negedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         ctr <= 0;
      end else begin
         // Check if counter is less than 16
         if (ctr < 16) begin
            // Shift multiplicand register by 1 bit
            multiplicand <= multiplicand << 1;
            // Check current bit of multiplier register
            if (multiplier[ctr]) begin
               // Accumulate product with current bit of multiplier
               p <= p + multiplicand[ctr];
               // Increment counter
               ctr <= ctr + 1;
            end else begin
               // Reset product and counter
               p <= 0;
               ctr <= 0;
            end
         end else begin
            // Set ready signal to 1 when counter reaches 16
            rdy <= 1;
         end
      end
   end

endmodule