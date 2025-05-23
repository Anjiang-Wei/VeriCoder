`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p; // 16-bit product output
   output reg rdy; // Ready signal

   // Internal registers
   reg [15:0] multiplicand, multiplier;
   reg [4:0] ctr; // 5-bit counter to count up to 16
   reg [15:0] accumulator; // Accumulator for intermediate product
   
   // Booth algorithm state machine
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // On reset, initialize all registers
         multiplicand <= {{8{a[7]}}, a}; // Sign-extend "a" to 16 bits
         multiplier <= {{8{b[7]}}, b}; // Sign-extend "b" to 16 bits
         accumulator <= 0; // Clear accumulator
         ctr <= 0; // Reset counter
         p <= 0; // Clear product output
         rdy <= 0; // Clear ready signal
      end else begin
         if (ctr < 8) begin
            // Check Booth's encoding (2 bits at a time)
            case ({multiplier[1:0]})
               2'b01: accumulator <= accumulator + multiplicand; // Add multiplicand
               2'b10: accumulator <= accumulator - multiplicand; // Subtract multiplicand
               default: ; // No operation for 2'b00 and 2'b11
            endcase
            
            // Arithmetic shift right (ASR) operation for Booth's algorithm
            multiplier <= {accumulator[0], multiplier[15:1]};
            accumulator <= {accumulator[15], accumulator[15:1]};
            
            // Increment counter
            ctr <= ctr + 1;
         end else begin
            // Multiplication complete
            p <= accumulator; // Assign the result to output
            rdy <= 1; // Set the ready signal
         end
      end
   end
endmodule