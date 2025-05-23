`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] multiplier, multiplicand, p;
   reg [4:0] ctr;
   wire rdy_wire;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         p <= 16'b0;
         ctr <= 5'b0;
         rdy_wire <= 1'b0;
      end else begin
         if (ctr < 16) begin
            multiplicand <= {1'b0, multiplicand[15:1]};
            if (multiplier[ctr] == 1'b1)
               p <= p + multiplicand;
            ctr <= ctr + 1;
         end else begin
            rdy_wire <= 1'b1;
         end
      end
   end

   assign rdy = rdy_wire;
   assign p = p;

endmodule