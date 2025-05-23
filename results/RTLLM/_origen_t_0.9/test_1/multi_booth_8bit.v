reg [15:0] multiplier, multiplicand, p;
   reg rdy;
   integer ctr;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         ctr <= 0;
         p <= 0;
         rdy <= 0;
      end
      else begin
         if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr] == 1) begin
               p <= p + multiplicand;
            end
            ctr <= ctr + 1;
         end
         else begin
            rdy <= 1;
         end
      end
   end
endmodule