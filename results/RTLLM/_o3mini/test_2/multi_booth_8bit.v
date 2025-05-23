module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input        clk, reset;
   input  [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;
   
   // Internal registers for the multiplier, multiplicand, and counter.
   reg [15:0] multiplier, multiplicand;
   reg [4:0]  ctr;  // 5-bit counter to allow counting from 0 to 16

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // On reset, initialize the registers:
         // The multiplier and multiplicand are sign-extended to 16 bits.
         multiplier   <= {{8{a[7]}}, a};  
         multiplicand <= {{8{b[7]}}, b};
         p            <= 16'b0;
         ctr          <= 5'b0;
         rdy          <= 1'b0;
      end
      else begin
         if (ctr < 16) begin
            // Check the current bit of the multiplier.
            if (multiplier[ctr] == 1'b1) begin
               p <= p + multiplicand;
            end
            // Left shift the multiplicand by 1 for the next cycle.
            multiplicand <= multiplicand << 1;
            // Increment the counter.
            ctr <= ctr + 1;
         end
         else begin
            // When all iterations (0 through 15) are performed, set ready.
            rdy <= 1'b1;
         end
      end
   end

endmodule