### Response:
module multi_pipe_8bit#(
    parameter size = 8
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

   reg mul_en_out_reg;
   reg [size-1:0] mul_a_reg, mul_b_reg;
   wire [size-1:0] temp [size-1:0];
   reg [size:0] sum [size-1:0];
   reg [size*2-1:0] mul_out_reg;
   integer i;

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_en_out_reg <= 1'b0;
         mul_a_reg <= {size{1'b0}};
         mul_b_reg <= {size{1'b0}};
         mul_out_reg <= {size*2{1'b0}};
         for (i = 0; i < size; i = i + 1) begin
            sum[i] <= {(size+1){1'b0}};
         end
      end else begin
         mul_en_out_reg <= mul_en_in;
         if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
         end
         for (i = 0; i < size; i = i + 1) begin
            if (mul_en_in) begin
               temp[i] <= mul_b_reg[i] ? mul_a_reg : {size{1'b0}};
               sum[i] <= temp[i] + (i > 0 ? sum[i-1] : {(size+1){1'b0}});
            end
         end
         mul_out_reg <= (mul_en_out_reg) ? sum[size-1] : {size*2{1'b0}};
      end
   end

   always @(*) begin
      mul_en_out = mul_en_out_reg;
      mul_out = mul_out_reg;
   end

endmodule