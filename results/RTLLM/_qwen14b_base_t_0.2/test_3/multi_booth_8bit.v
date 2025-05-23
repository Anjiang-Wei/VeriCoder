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
         multiplier <= {{8{a[7]}}, a};  // Sign extend a to 16 bits
         multiplicand <= {{8{b[7]}}, b};  // Sign extend b to 16 bits
         product <= 16'b0;  // Initialize product to 0
         ctr <= 5'b0;  // Initialize counter to 0
         rdy_int <= 1'b0;  // Indicate multiplication not complete
      end else begin
         if (ctr < 16) begin
            // Booth algorithm logic
            case ({multiplicand[15], multiplicand[15:1]})
               2'b00: begin  // 00 case, do nothing
                  // No operation
               end
               2'b01: begin  // 01 case, add multiplicand to product
                  product <= product + multiplicand;
               end
               2'b10: begin  // 10 case, subtract multiplicand from product
                  product <= product - multiplicand;
               end
               2'b11: begin  // 11 case, do nothing
                  // No operation
               end
            endcase

            // Left shift the multiplicand
            multiplicand <= {multiplicand[14:0], 1'b0};

            // Increment the counter
            ctr <= ctr + 1;
         end else begin
            // Multiplication complete
            rdy_int <= 1'b1;
         end
      end
   end
endmodule