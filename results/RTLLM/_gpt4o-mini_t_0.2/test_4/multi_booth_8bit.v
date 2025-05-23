`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;

   reg [15:0] multiplicand; // 16-bit multiplicand
   reg [15:0] multiplier;    // 16-bit multiplier
   reg [4:0] ctr;            // 5-bit counter for 16 iterations

   // State of the last two bits of multiplier
   reg [1:0] last_two_bits;

   // State machine
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // Initialize registers
         p <= 16'b0;
         multiplicand <= {{8{a[7]}}, a}; // Sign extend a to 16 bits
         multiplier <= {{8{b[7]}}, b};    // Sign extend b to 16 bits
         ctr <= 5'b0;
         rdy <= 0;
         last_two_bits <= 2'b00; // Initialize last two bits
      end
      else if (ctr < 16) begin
         last_two_bits <= {multiplier[ctr], last_two_bits[0]}; // Update last two bits
         // Process Booth's algorithm
         case (last_two_bits)
            2'b01: begin
               p <= p + multiplicand;             // Positive addition
            end
            2'b10: begin
               p <= p - multiplicand;             // Negative addition
            end
            default: begin
               p <= p; // No operation
            end
         endcase
         
         // Shift left the multiplicand (logical)
         multiplicand <= multiplicand << 1;
         // Shift right the multiplier (logical)
         multiplier <= {1'b0, multiplier[15:1]};
         ctr <= ctr + 1;
      end
      else begin
         rdy <= 1; // Set ready signal once multiplication is complete
      end
   end
endmodule