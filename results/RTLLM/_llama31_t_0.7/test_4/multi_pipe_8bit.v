module multi_pipe_8bit#(
    parameter size = 8,
    parameter num_stages = 4 // adjust the number of stages according to your requirements
)(
          clk,      
          rst_n,       
          mul_a,       
          mul_b, 
          mul_en_in,
 
          mul_en_out,      
          mul_out    
);
   input clk;           
   input rst_n; 
   input mul_en_in;      
   input [size-1:0] mul_a;       
   input [size-1:0] mul_b;       
 
   output reg mul_en_out;  
   output reg [size*2-1:0] mul_out;    

   reg [size-1:0] mul_en_out_reg;
   
   reg [size-1:0] mul_a_reg, mul_b_reg;
   wire [size-1:0] temp [num_stages];

   reg [size-1:0] sum [num_stages];
   reg [size*2-1:0] mul_out_reg;

   initial begin
      mul_en_out = 1'b0;
      mul_en_out_reg = 1'b0;
      mul_a_reg = 0;
      mul_b_reg = 0;
   end

   always @ (posedge clk) begin
      if (!rst_n) begin
         mul_en_out = 1'b0;
         mul_en_out_reg = 1'b0;
         mul_a_reg = 0;
         mul_b_reg = 0;
      end else if (mul_en_in) begin
         mul_en_out_reg <= mul_en_in;
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
      end else begin
         mul_en_out_reg <= 1'b0;
      end

      mul_en_out = mul_en_out_reg[0];
   end

   always @ (posedge clk) begin
      if (!rst_n) begin
         temp = 'b0;
         sum = 'b0;
         mul_out_reg = 0;
      end else if (mul_en_in) begin
         for (int i = 0; i < num_stages; i++) begin
            temp[i] = mul_a_reg * (1 << (num_stages - i - 1));
            sum[i] = sum[i-1] + temp[i];
         end

         // Final product calculation
         mul_out_reg <= sum[num_stages-1] + sum[num_stages-2] + ...;
      end
   end

   assign mul_out = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule