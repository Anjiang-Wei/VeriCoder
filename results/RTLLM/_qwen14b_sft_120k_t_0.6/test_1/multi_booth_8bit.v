`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] multiplier, multiplicand;
   reg [15:0] p_reg;
   reg [4:0] ctr;
   reg rdy_reg;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         p_reg <= 16'b0;
         ctr <= 5'b0;
         rdy_reg <= 1'b0;
      end else begin
         if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr]) begin
               p_reg <= p_reg + multiplicand;
            end
            ctr <= ctr + 1;
         end else begin
            rdy_reg <= 1'b1;
         end
      end
   end

   assign p = p_reg;
   assign rdy = rdy_reg;

endmodule