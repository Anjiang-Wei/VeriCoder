module top_level(clk,rst_n,mul_en_in,mul_a,mul_b);
    input clk;
    input rst_n; 
    input[7:0] mul_a;  
    input[7:0] mul_b;  
    output reg[15:0] mul_en_out;
    output[16*8-1:0] mul_out;      //16 bit product 
endmodule