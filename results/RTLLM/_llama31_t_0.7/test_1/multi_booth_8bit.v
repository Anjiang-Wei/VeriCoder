`timescale 1ns / 1ps

module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output reg rdy;

   reg [15:0] multiplier;
   reg [7:0] multiplicand;
   reg [5:0] ctr; // 6-bit counter to iterate through the bits of b
   wire [8:0] accum; // 9-bit accumulator for product calculation

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{b[7]}}, b};
         multiplicand <= {{8{a[7]}}, a};
         ctr <= 6'b00000; // initialize counter to 0
         rdy <= 1'b0;
      end
      else begin
         if (ctr < 16) begin
            multiplier[15:8] <= {multiplier[13:8], multiplier[7]};
            multiplicand <= {multiplicand, multiplicand};
            ctr <= ctr + 1;
            accum[8] <= multiplier[ctr];
            if (~accum[8]) begin // check for negative Booth encoding
               multiplicand <= multiplicand - {{8{multiplier[ctr+1]}, multiplier[ctr]}};
            end
            else begin // positive Booth encoding
               p <= {p, multiplicand};
            end
         end
         else begin
            rdy <= 1'b1; // ready signal is set to 1 when multiplication is complete
         end
      end
   end

endmodule