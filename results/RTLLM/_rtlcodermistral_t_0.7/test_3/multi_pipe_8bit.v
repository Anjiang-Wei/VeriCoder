```verilog
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   wire [size-1:0] mul_b_inv;
   wire [size*2-1:0] temp;
   reg [size*2-1:0] sum;
   reg [size*2-1:0] sum_reg;
   reg [size*2-1:0] mul_out_reg;
   integer i;

   assign mul_b_inv = ~mul_b;
   assign mul_en_out = mul_en_in;
   
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_a_reg <= 0;
         mul_b_reg <= 0;
         sum <= 0;
         sum_reg <= 0;
         mul_out_reg <= 0;
         mul_en_out <= 0;
         mul_out <= 0;
      end
      else begin
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
         sum <= 0;
         sum_reg <= 0;
         mul_out_reg <= 0;
         mul_en_out <= mul_en_in;
         for (i = 0; i < size; i = i + 1) begin
            if (mul_b_reg[i] == 1) begin
               sum <= sum + (mul_a_reg << i);
            end
         end
         sum_reg <= sum_reg + sum;
         mul_out_reg <= sum_reg;
         mul_out <= mul_out_reg;
      end
   end
   
endmodule