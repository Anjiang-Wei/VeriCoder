// 8-bit Radix-4 booth multiplier
   // Performs multiplication of two 8-bit inputs (a and b) using the Booth algorithm
   // Utilizes a clock signal (clk), and a reset signal (reset), and provides the product output (p) and a ready signal (rdy)
   // Ready signal (rdy) is set to 1 to indicate the completion of the multiplication process
   
   reg [15:0] multiplier, multiplicand;
   reg [4:0] ctr;
   reg [15:0] p;
   reg rdy;
   
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         ctr <= 0;
         p <= 0;
         rdy <= 0;
      end else begin
         if (ctr < 16) begin
            multiplicand <= {multiplicand[14:0], 1'b0};
            if (multiplier[ctr] == 1) begin
               p <= p + multiplicand;
            end
            ctr <= ctr + 1;
         end else begin
            rdy <= 1;
         end
      end
   end
   
endmodule