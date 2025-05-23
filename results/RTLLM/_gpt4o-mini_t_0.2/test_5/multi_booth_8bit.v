`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;

   reg [15:0] multiplicand; // Extended multiplicand
   reg [15:0] multiplier;    // Extended multiplier
   reg [4:0] ctr;           // 5-bit counter for up to 16 cycles
   reg [1:0] booth_rec;     // 2-bit to track current and previous bits of multiplier

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplicand <= {{8{a[7]}}, a}; // Sign-extend a
         multiplier <= {{8{b[7]}}, b};    // Sign-extend b
         p <= 16'b0;                      // Clear product
         rdy <= 1'b0;                     // Reset done signal
         ctr <= 5'b0;                     // Reset counter
         booth_rec <= 2'b0;               // Initialize Booth encoding record
      end else begin
         if (ctr < 16) begin
            booth_rec <= {multiplier[0], booth_rec[1]}; // Update booth record

            // Perform the Booth algorithm operation
            case (booth_rec)
               2'b01: p <= p + multiplicand; // Add multiplicand to product
               2'b10: p <= p - multiplicand; // Subtract multiplicand from product
               default: ;                   // Nothing to do
            endcase

            // Shift operation
            multiplicand <= multiplicand << 1; // Logical left shift on multiplicand
            multiplier <= {1'b0, multiplier[15:1]}; // Arithmetic shift right on multiplier

            ctr <= ctr + 1'b1; // Increment counter
         end else begin
            rdy <= 1'b1; // Set ready signal after completion
         end
      end
   end
endmodule