`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] multiplier, multiplicand, p_reg;
   reg [4:0] ctr;
   reg rdy_reg;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         p_reg <= 0;
         ctr <= 0;
         rdy_reg <= 0;
      end else begin
         if (ctr < 16) begin
            multiplicand <= {1'b0, multiplicand[15:1]};
            if (multiplier[ctr] == 1'b1) begin
               p_reg <= p_reg + multiplicand;
            end
            ctr <= ctr + 1;
         end else begin
            rdy_reg <= 1;
         end
      end
   end

   assign p = p_reg;
   assign rdy = rdy_reg;

endmodule