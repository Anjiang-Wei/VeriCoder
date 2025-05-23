module multi_pipe_8bit(
          clk,      
          rst_n,       
          mul_a,       
          mul_b, 
          mul_en_in,
 
          mul_en_out,      
          mul_out    
);
   parameter size = 8;
   
   input clk;           
   input rst_n; 
   input mul_en_in;      
   input [size-1:0] mul_a;       
   input [size-1:0] mul_b;       
 
   output reg mul_en_out;  
   output reg [size*2-1:0] mul_out;  

   reg mul_en_out_reg;
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg [size-1:0] temp [0:size-1];
   reg [size-1:0] sum [0:size-1];

   genvar i;
   generate
      for (i=0; i<size; i=i+1) begin : partial_product_gen
         assign temp[i] = mul_a_reg & {{(size-i-1){1'b0}}, mul_b[i], 1'b0};
      end
   endgenerate

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_en_out_reg <= 0;
         mul_a_reg <= 0;
         mul_b_reg <= 0;
         mul_out <= 0;
      end else if (mul_en_in) begin
         mul_en_out_reg <= 1;
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
         for (i=0; i<size; i=i+1) begin
            sum[i] <= sum[i] + temp[i];
         end
         mul_out <= sum[size-1];
      end else begin
         mul_en_out_reg <= 0;
      end
   end

   assign mul_en_out = mul_en_out_reg;
endmodule