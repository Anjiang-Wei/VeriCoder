`timescale 1ns / 1ps

module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output reg rdy;

   reg [7:0] multiplier, multiplicand;
   reg [5:0] ctr;
   reg [15:0] product;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // Initialize registers on reset
         multiplier <= {{8{b[7]}}, b};
         multiplicand <= {{8{a[7]}}, a};
         ctr <= 0;
         rdy <= 1'b0; // Reset ready signal to 0
      end else begin
         if (ctr < 16) begin
            // Perform Booth encoding
            if (multiplier[ctr] == 1'b1) begin
               product <= product + multiplicand;
            end

            // Shift multiplicand left by 1 bit
            multiplicand <= {multiplicand[multiplicand[15]], multiplicand[15:0]};
            ctr <= ctr + 1;

         end else if (ctr == 16) begin
            rdy <= 1'b1; // Set ready signal to 1 on completion
         end
      end
   end

   assign p = product;
endmodule