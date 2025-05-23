module multi_pipe_8bit#(parameter size = 8)(clk, rst_n, mul_a, mul_b, mul_en_in, mul_en_out, mul_out);
   input clk;           
   input rst_n; 
   input mul_en_in;      
   input [size-1:0] mul_a;       
   input [size-1:0] mul_b;       
 
   output reg mul_en_out;  
   output reg [size*2-1:0] mul_out;    
   
   // Input Control
   always # gate(clk) begin
      if (rst_n == 0) begin
         mul_en_out <= 0;
      end else begin
         mul_en_out <= mul_en_in;
      end
   end
   
   // Input Registers
   always # gate(clk) begin
      if (rst_n == 0) begin
         mul_a_reg <= 0;
         mul_b_reg <= 0;
      end else begin
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
      end
   end
   
   // Partial Product Generation
   always # gate(clk) begin
      for (int i = size-1; i > -1; i -= 1) begin
         temp[i] <= (mul_a_reg[i] & mul_b_reg[i]) + (mul_en_in == 1);
      end
   end
   
   // Partial Sum Calculation
   always # gate(clk) begin
      for (int i = size-1; i > -1; i -= 1) begin
         sum[i] <= temp[i];
      end
   end
   
   // Final Product Calculation
   always # gate(clk) begin
      if (mul_en_out == 1) begin
         mul_out <= sum;
      end else begin
         mul_out <= 0;
      end
   end
   
   // Output Assignment
   always # gate(clk) begin
      if (mul_en_out == 1) begin
         mul_out <= mul_out_reg;
      end else begin
         mul_out <= 0;
      end
   end
endmodule