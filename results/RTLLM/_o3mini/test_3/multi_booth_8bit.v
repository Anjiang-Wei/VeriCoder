module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input         clk, reset;
   input  [7:0]  a, b;
   output reg [15:0] p;
   output reg        rdy;
   
   // Internal 16-bit registers for multiplier and multiplicand
   reg [15:0] multiplier;
   reg [15:0] multiplicand;
   // 5-bit counter for 16 cycles of the operation
   reg [4:0] ctr;
   
   // Temporary variable to hold the shifted value
   reg [15:0] shifted;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // On reset, initialize:
         // - The multiplier register is set to the sign-extended value of 'a'.
         // - The multiplicand register is set to the sign-extended value of 'b'.
         // - The product 'p' is cleared.
         // - The counter is set to 0.
         // - The ready signal 'rdy' is cleared.
         multiplier   <= { {8{a[7]}}, a };
         multiplicand <= { {8{b[7]}}, b };
         p            <= 16'b0;
         ctr          <= 5'b0;
         rdy          <= 1'b0;
      end
      else begin
         if (ctr < 16) begin
            // Compute the next shifted multiplicand value.
            shifted = multiplicand << 1;
            // Update the multiplicand register (shift left by 1)
            multiplicand <= shifted;
            // If the bit at position 'ctr' of the multiplier is 1, accumulate
            if (multiplier[ctr] == 1'b1)
               p <= p + shifted;
            // Increment the counter.
            ctr <= ctr + 1;
         end
         else begin
            // When 16 iterations are complete, set the ready flag.
            rdy <= 1'b1;
         end
      end
   end
endmodule