`timescale 1ns / 1ps
module multi_booth_8bit (
    p, 
    rdy, 
    clk, 
    reset, 
    a, 
    b
);
   //-------------------------------------------------------------------------
   // Ports
   //-------------------------------------------------------------------------
   input        clk;        // Clock
   input        reset;      // Active‐high synchronous reset
   input  [7:0] a;          // Multiplicand
   input  [7:0] b;          // Multiplier
   output reg [15:0] p;     // Product
   output reg       rdy;    // Result ready

   //-------------------------------------------------------------------------
   // Internal registers
   //-------------------------------------------------------------------------
   reg [15:0] multiplicand; // Shifted multiplicand (sign‐extended)
   reg [15:0] multiplier;   // Multiplier (sign‐extended)
   reg [4:0]  ctr;          // Cycle counter (0..16)

   //-------------------------------------------------------------------------
   // Sequential multiply process
   //-------------------------------------------------------------------------
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // Initialize on reset
         //   sign‐extend inputs to 16 bits
         multiplicand <= {{8{a[7]}}, a};
         multiplier   <= {{8{b[7]}}, b};
         // clear product, counter, ready flag
         p            <= 16'd0;
         ctr          <= 5'd0;
         rdy          <= 1'b0;
      end else begin
         if (!rdy) begin
            if (ctr < 5'd16) begin
               // If current multiplier bit is 1, add shifted multiplicand
               if (multiplier[ctr])
                  p <= p + multiplicand;
               // Shift multiplicand left for next bit position
               multiplicand <= multiplicand << 1;
               // Next cycle
               ctr <= ctr + 1;
            end else begin
               // Done after 16 cycles
               rdy <= 1'b1;
            end
         end
      end
   end

endmodule