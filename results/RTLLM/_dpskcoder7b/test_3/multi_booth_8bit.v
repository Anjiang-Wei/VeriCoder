reg [15:0] p;
   reg [4:0] ctr;
   reg [15:0] multiplier, multiplicand;
   reg rdy;
   
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         ctr <= 5'b0;
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         p <= 16'b0;
         rdy <= 1'b0;
      end else begin
         if (ctr < 16) begin
            multiplier <= {1'b0, multiplier[15:1]};
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr] == 1'b1) begin
               p <= p + multiplicand;
            end else if (multiplier[ctr] == 1'b0) begin
               p <= p;
            end else begin
               p <= p - multiplicand;
            end
            ctr <= ctr + 1'b1;
         end else begin
            rdy <= 1'b1;
         end
      end
   end
endmodule