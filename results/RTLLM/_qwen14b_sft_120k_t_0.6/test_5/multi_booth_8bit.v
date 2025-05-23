`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] multiplier, multiplicand, p_reg;
   reg [4:0] ctr;
   wire [15:0] multiplicand_shifted;

   // Shift multiplicand to maintain 16-bit alignment with multiplier
   assign multiplicand_shifted = {multiplicand[15], multiplicand[15:1]};

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a}; // Initialize multiplier
         multiplicand <= {{8{b[7]}}, b}; // Initialize multiplicand
         p_reg <= 16'b0; // Clear product register
         ctr <= 5'd0; // Reset counter
         rdy <= 1'b0; // Clear ready signal
      end else begin
         if (ctr < 16) begin
            multiplicand <= multiplicand_shifted; // Shift multiplicand left
            if (multiplier[ctr] == 1'b1) begin
               p_reg <= p_reg + multiplicand; // Add multiplicand if multiplier bit is 1
            end
            ctr <= ctr + 1; // Increment counter
         end else begin
            rdy <= 1'b1; // Set ready signal
         end
      end
   end

   assign p = p_reg; // Output product

endmodule