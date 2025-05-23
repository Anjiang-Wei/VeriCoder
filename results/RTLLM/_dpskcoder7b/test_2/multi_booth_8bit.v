// Internal Registers
   reg [15:0] multiplier, multiplicand, product;
   reg [4:0] ctr;
   reg rdy;

   // Counter Initialization
   initial ctr = 0;

   // Multiplier and multiplicand Initialization
   initial begin
      multiplier <= {{8{a[7]}}, a};
      multiplicand <= {{8{b[7]}}, b};
   end

   // Synchronous Logic
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         ctr <= 0;
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         product <= 0;
         rdy <= 0;
      end else if (ctr < 16) begin
         multiplicand <= multiplicand << 1;
         if (multiplier[ctr] == 1) begin
            product <= product + multiplicand;
         end
         ctr <= ctr + 1;
      end else begin
         p <= product;
         rdy <= 1;
      end
   end
endmodule