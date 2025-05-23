module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] multiplier, multiplicand;
   reg [4:0] ctr;
   reg [15:0] product;
   reg ready;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         ctr <= 5'b00000;
         product <= 16'b0;
         ready <= 1'b0;
      end
      else begin
         if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr]) begin
               product <= product + multiplicand;
            end
            ctr <= ctr + 1;
         end
         else begin
            ready <= 1'b1;
         end
      end
   end

   assign p = product;
   assign rdy = ready;

endmodule