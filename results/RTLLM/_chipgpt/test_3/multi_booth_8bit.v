module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;
   
   wire cnt_done; 
   wire[4:0] q_reg; //5'b1111_1 for positive Booth encoding and 5'b0_0_1_1 for negative Booth encoding
   
   booth_8bit b0  (p, cnt_done, clk, reset, a, q_reg[3:0]); //q_reg is left-shifted by one whenever the counter "cnt" equals to 16(starting from state 5'b1_1_0_0)
   booth_8bit b1 (p, cnt_done, clk, reset, q_reg[4:0], q_reg[7:4]); //q_reg is left-shifted by two whenever the counter "cnt" equals to 32(starting from state 5'b0_0_1_1)
   booth_8bit b2 (p, cnt_done, clk, reset, q_reg[7:4], q_reg[10:8]); //q_reg is left-shifted by four whenever the counter "cnt" equals to 64(starting from state 5'b1111_1)
   
   assign rdy = cnt_done;//ready signal indicating completion of multiplication process
endmodule