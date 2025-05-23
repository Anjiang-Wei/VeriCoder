`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   // Registers for multiplicand and multiplier
   reg [15:0] multiplicand, multiplier;

   // Counter for Booth algorithm
   reg [4:0] ctr;

   always @(posedge clk or negedge reset) begin
      if (reset == 0) begin
         // Initialize registers
         multiplicand <= {{8{a[7]}}, a};
         multiplier <= {{8{b[7]}}, b};

         // Set counter to 0
         ctr <= 0;
      end else begin
         // Check if counter is less than 16
         if (ctr < 16) begin
            // Shift multiplicand register left by 1 bit
            multiplicand <= {multiplicand[6], multiplicand[5], multiplicand[4], multiplicand[3], multiplicand[2], multiplicand[1], a[7]};

            // Check if current bit of multiplier register is 1
            if (multiplier[ctr]) begin
               // Accumulate product of multiplicand and multiplier
               p <= multiplicand + multiplier;

               // Increment counter
               ctr <= ctr + 1;
            end else begin
               // Reset counter
               ctr <= 0;
            end
         end else begin
            // Set ready signal to 1 when counter reaches 16
            rdy <= 1;
         end
      end
   end
endmodule