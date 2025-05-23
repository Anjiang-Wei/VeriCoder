`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   // Registers for multiplier and multiplicand
   reg [8:0] multiplier = {{8{a[7]}}, a};
   reg [8:0] multiplicand = {{8{b[7]}}, b};

   // Counter for Booth algorithm
   reg ctr = 0;

   // Ready signal for multiplication completion
   output rdy = 0;

   // Multiplication process
   always @(posedge clk or posedge reset) begin
      if (reset == 1) begin
         multiplier <= multiplicand;
         ctr <= 0;
      end else begin
         if (ctr < 16) begin
            // Shift multiplicand register by 1 bit
            multiplicand <= {multiplicand[7], 1'b0};
         end else begin
            // Multiply current bit of multiplier register with multiplicand register
            p <= multiplier[ctr] * multiplicand[ctr];
            ctr <= ctr + 1;
            rdy <= 1; // Set ready signal to indicate completion of multiplication
         end
      end
   end
endmodule