reg [15:0] multiplicand, multiplier, p;
   reg [4:0] ctr;
   reg rdy;

   // Initialize the multiplier and multiplicand registers and the ready signal
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplicand <= {{8{a[7]}}, a};
         multiplier <= {{8{b[7]}}, b};
         p <= 16'b0;
         ctr <= 5'b0;
         rdy <= 1'b0;
      end else if (ctr < 16) begin
         multiplicand <= {multiplicand[14:0], 1'b0};
         if (multiplier[ctr] == 1'b1) begin
            p <= p + multiplicand;
         end
         ctr <= ctr + 1'b1;
      end else begin
         rdy <= 1'b1;
      end
   end
endmodule