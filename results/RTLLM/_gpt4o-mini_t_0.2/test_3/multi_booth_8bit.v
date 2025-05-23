`timescale 1ns / 1ps

module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;

   reg [15:0] multiplicand;      // extended multiplicand
   reg [15:0] multiplier;         // extended multiplier
   reg [4:0] ctr;                // counter for bit processing

   always @(posedge clk or posedge reset) begin
       if (reset) begin
           multiplicand <= {{8{a[7]}}, a}; // sign-extend a
           multiplier <= {{8{b[7]}}, b};    // sign-extend b
           p <= 16'b0;                      // Clear product
           ctr <= 5'b0;                     // Reset counter
           rdy <= 0;                        // Clear ready signal
       end else begin
           if (ctr < 16) begin
               // Perform the Booth multiplication process
               case ({multiplier[ctr+1], multiplier[ctr]}) // Look at current and next bits
                   2'b00: begin // do nothing
                       multiplicand <= multiplicand; // No action
                   end
                   2'b01: begin // add multiplicand to product
                       p <= p + multiplicand; // Add multiplicand to product
                   end
                   2'b10: begin // subtract multiplicand from product
                       p <= p - multiplicand; // Subtract multiplicand from product
                   end
                   2'b11: begin // do nothing
                       multiplicand <= multiplicand; // No action
                   end
               endcase
               
               // Shift left for the next bit
               multiplicand <= multiplicand << 1; // Shift multiplicand left
               multiplier <= multiplier >> 1; // Shift multiplier right
               
               ctr <= ctr + 1; // Increment counter
           end else begin
               rdy <= 1; // Set ready signal when done
           end
       end
   end

endmodule