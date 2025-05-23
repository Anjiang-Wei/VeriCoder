`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   // Internal signals and registers
   reg [15:0] multiplier, multiplicand;
   reg [15:0] product;
   reg [4:0] ctr;
   reg rdy_int;

   // Assign the output ready signal
   assign rdy = rdy_int;

   // Assign the output product signal
   assign p = product;

   // Initialize the multiplier and multiplicand registers on reset
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a}; // Sign extend a to 16 bits
         multiplicand <= {{8{b[7]}}, b}; // Sign extend b to 16 bits
         product <= 16'b0; // Initialize product to 0
         ctr <= 5'b0; // Initialize counter to 0
         rdy_int <= 1'b0; // Initialize ready signal to 0
      end else begin
         // Normal operation
         if (ctr < 16) begin
            // Left shift the multiplicand by 1
            multiplicand <= {multiplicand[14:0], 1'b0};

            // Check the current bit of the multiplier
            case (multiplier[ctr+1:ctr])
               2'b00: begin // Do nothing
               end
               2'b01: begin // Add multiplicand to product
                  product <= product + multiplicand;
               end
               2'b10: begin // Subtract multiplicand from product
                  product <= product - multiplicand;
               end
               2'b11: begin // Do nothing
               end
            endcase

            // Increment the counter
            ctr <= ctr + 1;
         end else begin
            // Multiplication completed
            rdy_int <= 1'b1;
         end
      end
   end
endmodule