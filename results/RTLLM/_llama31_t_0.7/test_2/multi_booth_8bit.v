`timescale 1ns / 1ps

module multi_booth_8bit (
   output reg [15:0] p,
   output reg rdy,
   input clk, reset,
   input [7:0] a, b
);

reg [7:0] multiplicand;
reg [7:0] multiplier;

wire [4:0] ctr;

always @(posedge clk or posedge reset)
begin
   if (reset)
   begin
      multiplicand <= {{8{a[7]}}, a};
      multiplier <= {{8{b[7]}}, b};
      p <= 16'b0;
      rdy <= 1'b0;
      ctr <= 5'b00000;
   end
   else
   begin
      if (ctr < 16)
      begin
         multiplicand <= {multiplicand >> 1, multiplicand[7]};
         if (multiplier[ctr] == 1)
           p <= p + multiplicand;
         ctr <= ctr + 1;
      end
      else
      begin
         rdy <= 1'b1;
      end
   end
end

endmodule