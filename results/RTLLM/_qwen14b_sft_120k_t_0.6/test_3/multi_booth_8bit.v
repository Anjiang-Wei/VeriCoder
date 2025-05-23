`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] multiplier, multiplicand, p;
   reg [4:0] ctr;
   wire [1:0] booth_code;

   // Booth encoding logic
   assign booth_code = {multiplier[0], multiplier[1]};
   assign rdy = (ctr == 16);

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         p <= 0;
         ctr <= 0;
      end else begin
         if (ctr < 16) begin
            multiplicand <= multiplicand << 1; // Shift multiplicand left
            case (booth_code)
               2'b00: begin end
               2'b01: p <= p + multiplicand; // Add multiplicand
               2'b10: p <= p - multiplicand; // Subtract multiplicand
               2'b11: begin end
            endcase
            multiplier <= {multiplier[14:0], 1'b0}; // Shift multiplier left
            ctr <= ctr + 1;
         end
      end
   end

   // Output assignment
   assign p = p;
endmodule