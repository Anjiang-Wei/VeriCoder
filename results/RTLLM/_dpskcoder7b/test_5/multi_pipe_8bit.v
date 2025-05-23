reg mul_en_out_reg;
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg [size-1:0] temp[0:size-1];
   reg [size-1:0] sum[0:size-1];
   reg [size*2-1:0] mul_out_reg;
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_en_out_reg <= 0;
         mul_a_reg <= 0;
         mul_b_reg <= 0;
         mul_out_reg <= 0;
         mul_en_out <= 0;
      end else if (mul_en_in) begin
         mul_en_out_reg <= 1;
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
         mul_out_reg <= 0;
         mul_en_out <= mul_en_out_reg;
      end else begin
         mul_en_out_reg <= 0;
         mul_en_out <= mul_en_out_reg;
      end
   end
   
   genvar i;
   generate
      for (i = 0; i < size; i = i + 1) begin : partial_product_gen
         assign temp[i] = mul_a_reg & {size{mul_b_reg[i]}} ;
      end
   endgenerate
   
   genvar j;
   generate
      for (j = 0; j < size; j = j + 1) begin : partial_sum_calc
         always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
               sum[j] <= 0;
            end else if (mul_en_in) begin
               sum[j] <= sum[j-1] + temp[j];
            end
         end
      end
   endgenerate
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_out_reg <= 0;
      end else if (mul_en_in) begin
         mul_out_reg <= sum[size-1];
      end
   end
   
   assign mul_out = mul_en_out_reg ? mul_out_reg : 0;
   
endmodule