module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;

   reg [15:0] multiplier, multiplicand;
   reg [4:0] ctr;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         p <= 16'b0;
         ctr <= 5'b0;
         rdy <= 1'b0;
      end
      else begin
         if (ctr < 5'd16) begin
            multiplicand <= multiplicand << 1;
            
            if (multiplier[ctr]) begin
               p <= p + multiplicand;
            end
            else begin
               p <= p - multiplicand;
            end
            
            ctr <= ctr + 1;
         end
         else begin
            rdy <= 1'b1;
         end
      end
   end
endmodule