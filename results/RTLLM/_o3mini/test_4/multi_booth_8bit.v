module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;
   
   // Internal registers.
   reg [15:0] multiplier;    // Holds extended version of a.
   reg [15:0] multiplicand;  // Holds extended version of b.
   reg [15:0] prod;          // Accumulated product.
   reg [4:0] ctr;          // 5-bit counter to count to 16.
   reg ready;               // Internal ready signal.
   
   // Assign outputs.
   assign p = prod;
   assign rdy = ready;
   
   // Synchronous block with asynchronous reset.
   always @(posedge clk or posedge reset)
   begin
      if (reset) begin
         // On reset: 
         // Initialize multiplier and multiplicand with sign extension.
         // Clear product and counter and lower ready.
         multiplier   <= { {8{a[7]}}, a };
         multiplicand <= { {8{b[7]}}, b };
         prod         <= 16'd0;
         ctr          <= 5'd0;
         ready        <= 1'b0;
      end
      else begin
         // Only process if multiplication is not complete.
         if (ctr < 16) begin
            // If the current bit of multiplier is 1, add the multiplicand.
            if (multiplier[ctr] == 1'b1)
               prod <= prod + multiplicand;
            // Left shift the multiplicand by 1 bit on every cycle.
            multiplicand <= multiplicand << 1;
            // Increment the counter.
            ctr <= ctr + 1;
            // When the counter reaches 16, set ready; note that we
            // will indicate ready after the final operation.
            if (ctr == 15)
               ready <= 1'b1;
         end
      end
   end
endmodule