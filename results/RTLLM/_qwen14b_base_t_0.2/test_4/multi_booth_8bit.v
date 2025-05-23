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
   reg rdy_reg;

   // Assign the output ready signal
   assign rdy = rdy_reg;

   // Assign the output product signal
   assign p = product;

   // Initialize the multiplier and multiplicand registers on reset
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         product <= 16'b0;
         ctr <= 5'b0;
         rdy_reg <= 1'b0;
      end else begin
         // Perform the Booth multiplication
         if (ctr < 16) begin
            // Left shift the multiplicand
            multiplicand <= {multiplicand[14:0], 1'b0};

            // Check the Booth encoding
            case ({multiplicand[15], multiplicand[14]})
               2'b00: begin
                  // Do nothing
               end
               2'b01: begin
                  product <= product + multiplicand;
               end
               2'b10: begin
                  product <= product - multiplicand;
               end
               2'b11: begin
                  // Do nothing
               end
            endcase

            // Increment the counter
            ctr <= ctr + 1;
         end else begin
            // Multiplication is complete
            rdy_reg <= 1'b1;
         end
      end
   end
endmodule