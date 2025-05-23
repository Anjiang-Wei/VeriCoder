reg [7:0] a_reg, b_reg;
   reg [7:0] multiplier [15:0];
   reg [4:0] ctr;
   reg [7:0] multiplicand_reg;
   reg [15:0] p_reg;
   reg rdy_reg;
   
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         a_reg <= {8{a[7]}}, a;
         b_reg <= {8{b[7]}}, b;
         ctr <= 0;
         multiplicand_reg <= 0;
         p_reg <= 0;
         rdy_reg <= 0;
      end
      else begin
         if (ctr < 16) begin
            if (multiplier[ctr] == 1) begin
               p_reg <= p_reg + multiplicand_reg;
            end
            multiplicand_reg <= multiplicand_reg << 1;
            ctr <= ctr + 1;
         end
         else begin
            rdy_reg <= 1;
         end
      end
   end
   
   assign p = p_reg;
   assign rdy = rdy_reg;
   
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier[15] <= 0;
         multiplier[14] <= 0;
         multiplier[13] <= 0;
         multiplier[12] <= 0;
         multiplier[11] <= 0;
         multiplier[10] <= 0;
         multiplier[9] <= 0;
         multiplier[8] <= 0;
         multiplier[7] <= 0;
         multiplier[6] <= 0;
         multiplier[5] <= 0;
         multiplier[4] <= 0;
         multiplier[3] <= 0;
         multiplier[2] <= 0;
         multiplier[1] <= 0;
         multiplier[0] <= 0;
      end
      else begin
         multiplier[ctr] <= b_reg[ctr];
      end
   end
   
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         a_reg <= 0;
         b_reg <= 0;
      end
      else begin
         a_reg <= a;
         b_reg <= b;
      end
   end
   
endmodule
```