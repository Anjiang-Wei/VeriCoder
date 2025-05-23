`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] multiplier, multiplicand, product;
   reg [4:0] ctr;
   reg rdy_sig;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         product <= 16'b0;
         ctr <= 5'b0;
         rdy_sig <= 1'b0;
      end
      else if (ctr < 16) begin
         multiplier <= {multiplier[14:0], 1'b0};
         if (multiplier[ctr]) begin
            product <= product + multiplicand;
         end
         ctr <= ctr + 1;
      end
      else begin
         p <= product;
         rdy_sig <= 1'b1;
      end
   end

   assign p = product;
   assign rdy = rdy_sig;
endmodule