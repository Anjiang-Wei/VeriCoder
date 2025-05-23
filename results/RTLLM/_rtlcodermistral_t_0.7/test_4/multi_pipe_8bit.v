```verilog
   reg [size-1:0] mul_a_reg;   
   reg [size-1:0] mul_b_reg;   
   wire [size-1:0] temp [size:0];     
   reg [size*2-1:0] sum;           
   reg [size*2-1:0] mul_out_reg;     
   
   always @ (posedge clk, negedge rst_n) begin
      if (~rst_n) begin
         mul_a_reg <= 0;       
         mul_b_reg <= 0;       
         sum <= 0;            
         mul_out_reg <= 0;    
         mul_en_out <= 0;     
         mul_out <= 0;        
      end
      else begin
         if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out <= 1;
         end
         else begin
            mul_en_out <= 0;
         end
         for (size_t i = 0; i < size; i = i + 1) begin
            if (mul_b[i]) begin
               temp[i] <= mul_a_reg;
            end
            else begin
               temp[i] <= 0;
            end
         end
         for (size_t i = 0; i < size; i = i + 1) begin
            if (i == 0) begin
               sum <= temp[i];
            end
            else begin
               sum <= sum + temp[i];
            end
         end
         mul_out_reg <= sum;
         mul_out <= mul_out_reg;
      end
   end

endmodule