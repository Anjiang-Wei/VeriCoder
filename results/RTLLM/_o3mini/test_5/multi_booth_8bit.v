module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input         clk, reset;
   input  [7:0]  a, b;
   output [15:0] p;
   output        rdy;
   
   // Internal registers for the signed extended versions of a and b.
   reg [15:0] multiplicand;  // holds the (shifted) signed extended b
   reg [15:0] multiplier;    // holds the signed extended a (bit‐wise used for addition control)
   reg [15:0] p;             // product accumulator
   reg [4:0]  ctr;           // 5‐bit counter (counts from 0 to 16)
   reg        rdy;
   
   // Synchronous process: on reset initialize registers,
   // otherwise perform one multiplication step per clock.
   always @(posedge clk or posedge reset)
   begin
      if (reset) begin
         // On reset, initialize the multiplier and multiplicand using sign‐extension,
         // clear the product accumulator and counter, and clear the ready signal.
         multiplier   <= { {8{a[7]}}, a };
         multiplicand <= { {8{b[7]}}, b };
         p            <= 16'b0;
         ctr          <= 5'b0;
         rdy          <= 1'b0;
      end 
      else begin
         if (ctr < 16) begin
            // Check the current bit of the multiplier.
            // If the multiplier bit at position ctr is 1, add the current multiplicand value to the product.
            if (multiplier[ctr])
               p <= p + multiplicand;
               
            // Shift the multiplicand left by 1 to simulate the Booth shifting operation.
            multiplicand <= multiplicand << 1;
            
            // Increment our counter.
            ctr <= ctr + 1;
         end
         
         // Once the counter has reached 16, indicate the product is ready.
         if (ctr == 16)
            rdy <= 1'b1;
      end
   end

endmodule