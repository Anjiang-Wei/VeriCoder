reg [7:0] a, b;
   reg [7:0] multiplier, multiplicand;
   reg [4:0] ctr;
   reg [15:0] p;
   reg rdy;
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         a <= 8'b0;
         b <= 8'b0;
         multiplier <= 8'b0;
         multiplicand <= 8'b0;
         ctr <= 5'b0;
         p <= 16'b0;
         rdy <= 1'b0;
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
            rdy <= 1'b1;
         end
      end
   end
   
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= a;
         a <= 8'b0;
         b <= b;
      end
      else begin
         if (ctr < 16) begin
            multiplier <= multiplier << 1;
            multiplier[0] <= b[0];
            b <= b >> 1;
         end
      end
   end
endmodule
```
Please complete the code above and return the complete module code directly. Thank you.