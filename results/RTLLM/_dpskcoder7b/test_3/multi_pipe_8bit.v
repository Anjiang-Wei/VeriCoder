reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg mul_en_out_reg;
   wire [size-1:0] temp [size-1:0];
   wire [size*2-1:0] sum [size-1:0];
   reg [size*2-1:0] mul_out_reg;
   
   // Input Control
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_en_out_reg <= 0;
      end else begin
         mul_en_out_reg <= mul_en_in;
      end
   end

   // Input Registers
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_a_reg <= 0;
         mul_b_reg <= 0;
      end else if (mul_en_in) begin
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
      end
   end

   // Partial Product Generation
   genvar i;
   generate
      for (i = 0; i < size; i = i + 1) begin : gen_partial_product
         assign temp[i] = mul_a_reg & {size{mul_b_reg[i]}};
      end
   endgenerate

   // Partial Sum Calculation
   generate
      for (i = 0; i < size; i = i + 1) begin : gen_partial_sum
         always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
               sum[i] <= 0;
            end else if (mul_en_in) begin
               sum[i] <= sum[i-1] + temp[i];
            end
         end
      end
   endgenerate

   // Final Product Calculation
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_out_reg <= 0;
      end else if (mul_en_in) begin
         mul_out_reg <= sum[size-1];
      end
   end

   // Output Assignment
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_en_out <= 0;
         mul_out <= 0;
      end else if (mul_en_in) begin
         mul_en_out <= mul_en_out_reg;
         mul_out <= mul_out_reg;
      end else begin
         mul_out <= 0;
      end
   end

endmodule