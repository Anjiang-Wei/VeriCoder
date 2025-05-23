`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;

   // Internal registers and wires
   reg [4:0] ctr;  // 5-bit counter
   reg [15:0] multiplier;
   reg [15:0] multiplicand;
   reg [15:0] temp_product;

   initial begin
       p = 0;
       rdy = 0;
       ctr = 0;
       multiplier = 0;
       multiplicand = 0;
       temp_product = 0;
   end

   always @(posedge clk or posedge reset) begin
       if (reset) begin
           // Reset all internal registers
           multiplier <= {{8{a[7]}}, a};  // Sign-extend multiplicand
           multiplicand <= {{8{b[7]}}, b}; // Sign-extend multiplier
           p <= 0;
           temp_product <= 0;
           ctr <= 0;
           rdy <= 0;
       end else begin
           if (ctr < 8) begin
               // Perform Booth decoding and operation
               if (multiplier[1:0] == 2'b01) begin
                   temp_product = temp_product + multiplicand;  // Add multiplicand for partial product
               end else if (multiplier[1:0] == 2'b10) begin
                   temp_product = temp_product - multiplicand;  // Subtract multiplicand for partial product
               end

               // Arithmetic shift right
               multiplicand = multiplicand << 2;  // Shift multiplicand left by 2 (Radix-4 shift)
               multiplier = multiplier >> 2;     // Shift multiplier right by 2
               ctr = ctr + 1;                    // Increment counter
           end else begin
               // Multiplication operation complete
               p <= temp_product;
               rdy <= 1;
           end
       end
   end
endmodule