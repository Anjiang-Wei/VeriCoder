`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p; // Register output for product
   output reg rdy; // Ready signal
   
   reg [15:0] multiplicand; // 16-bit multiplicand ({{8{a[7]}}, a})
   reg [15:0] multiplier;   // 16-bit multiplier ({{8{b[7]}}, b})
   reg [4:0] ctr;           // 5-bit counter for counting steps
   reg [1:0] state;         // State variable for the state machine

   parameter IDLE = 2'b00, RUN = 2'b01, DONE = 2'b10;

   // Sequential logic
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // Initialize registers
         multiplicand <= {{8{a[7]}}, a}; // Sign extend a
         multiplier <= {{8{b[7]}}, b};   // Sign extend b
         p <= 0;                        // Reset product
         ctr <= 0;                      // Reset counter
         rdy <= 0;                     // Reset ready signal
         state <= IDLE;                // Set state to IDLE
      end else begin
         case (state)
            IDLE: begin
               // Transition to RUN state
               state <= RUN;
            end
            
            RUN: begin
               // Booth's algorithm implementation
               if (ctr < 16) begin
                  if (multiplier[ctr[3:0]:ctr[3:0]+1] == 2'b01) begin
                     p <= p + multiplicand; // Add multiplicand on positive encoding
                  end else if (multiplier[ctr[3:0]:ctr[3:0]+1] == 2'b10) begin
                     p <= p - multiplicand; // Subtract multiplicand on negative encoding
                  end
                  
                  // Arithmetic right shift to prepare for the next iteration
                  multiplicand <= multiplicand << 1; // Left shift multiplicand
                  ctr <= ctr + 1;                    // Increment counter
               end else begin
                  // All iterations completed, transition to DONE state
                  state <= DONE;
               end
            end
            
            DONE: begin
               rdy <= 1; // Set ready signal
            end
         endcase
      end
   end
endmodule