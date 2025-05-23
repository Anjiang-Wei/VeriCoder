module multi_pipe_8bit#(parameter size = 8)(
    input clk,      
    input rst_n,       
    input mul_en_in,      
    input [size-1:0] mul_a,       
    input [size-1:0] mul_b, 
    output reg mul_en_out,      
    output reg [size*2-1:0] mul_out    
);
   wire clk;           
   wire rst_n; 
   wire mul_en_in;      
   wire [size-1:0] mul_a;       
   wire [size-1:0] mul_b;       
   reg [size*2-1:0] mul_out;    
   assign mul_en_out = (mul_a & mul_en_in) ? 1 : 0;
   
   always @(posedge clk or posedge rst_n) begin
      if (rst_n == 0) begin
         mul_out <= 0;
      end else begin
         // Input Control
         if (mul_en_in) begin
            // Sample input values and store in registers
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
         end
         
         // Partial Product Generation
         for (int i = 0; i < size; i++) begin
            wire temp;
            temp <= (mul_a_reg[i] & mul_b_reg[i]);
            mul_out <= temp;
         end
         
         // Partial Sum Calculation
         for (int i = 0; i < size; i++) begin
            reg sum[size];
            sum[i] <= (mul_out[i] + sum[i-1]);
         end
         
         // Final Product Calculation
         mul_out_reg <= sum[size*2-1];
      end
   end
   
   assign mul_out = mul_en_out ? mul_out_reg : 0;