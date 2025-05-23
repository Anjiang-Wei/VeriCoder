module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;

   reg [15:0] multiplicand, multiplier;
   reg [4:0] ctr;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         ctr <= 5'b0;
         p <= 16'b0;
         rdy <= 1'b0;
      end
      else begin
         if (ctr < 16) begin
            multiplicand <= {multiplicand[14:0], 1'b0};
            if (multiplier[ctr]) begin
               case ({multiplier[ctr+1], multiplier[ctr]})
                  2'b10: p <= p - multiplicand;
                  2'b01: p <= p + multiplicand;
                  default: p <= p;
               endcase
            end
            multiplier <= {multiplier[15:1], 1'b0};
            ctr <= ctr + 1;
         end
         else begin
            rdy <= 1'b1;
         end
      end
   end
endmodule