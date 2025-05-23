module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input         clk, reset;
   input  [7:0]  a, b;
   output [15:0] p;
   output        rdy;
   
   // Internal registers: p_reg holds the accumulated product.
   reg [15:0] p_reg;
   // Multiplier and multiplicand registers (sign–extended to 16 bits)
   reg [15:0] multiplier;
   reg [15:0] multiplicand;
   // 5-bit counter for 16 clock cycles
   reg [4:0] ctr;
   reg       rdy_reg;
   
   // Output assignments
   assign p   = p_reg;
   assign rdy = rdy_reg;
   
   // Sequential block: operates on the rising edge of clock or reset.
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // On reset, initialize multiplier and multiplicand by sign–extending
         multiplier   <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         p_reg        <= 16'b0;
         ctr          <= 5'b0;
         rdy_reg      <= 1'b0;
      end
      else if (ctr < 16) begin
         // If in progress: if the current bit of the multiplier is 1,
         // add the current multiplicand to the product.
         if (multiplier[ctr] == 1'b1)
            p_reg <= p_reg + multiplicand;
         
         // Left–shift the multiplicand register (simulate Booth’s shifting)
         multiplicand <= multiplicand << 1;
         
         // Increment the cycle counter.
         ctr <= ctr + 1;
         
         // Still in progress so not ready.
         rdy_reg <= 1'b0;
      end
      else begin
         // When 16 cycles have been executed, multiplication is complete.
         rdy_reg <= 1'b1;
      end
   end
endmodule