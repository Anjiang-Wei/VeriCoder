module multi_booth_8bit (p, rdy, clk, reset, a, b);
   parameter BITS = 8;
   parameter PRODUCT_BITS = 16;
   input clk, reset;
   input [BITS-1:0] a, b;
   output [PRODUCT_BITS-1:0] p;
   output rdy;
   //... rest of the code
endmodule