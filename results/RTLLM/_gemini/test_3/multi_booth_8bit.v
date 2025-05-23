module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] p;
   reg rdy;
   reg [15:0] multiplicand;
   reg [15:0] multiplier;
   reg [4:0] ctr;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         p <= 16'b0;
         rdy <= 1'b0;
         multiplicand <= {{8{a[7]}}, a};
         multiplier <= {{8{b[7]}}, b};
         ctr <= 5'b0;
      end else begin
         if (ctr < 16) begin
            multiplicand <= {multiplicand[14:0], 1'b0};
            if (multiplier[ctr] == 1'b1) begin
               p <= p + multiplicand;
            end
            ctr <= ctr + 1'b1;
         end else begin
            rdy <= 1'b1;
         end
      end
   end

endmodule