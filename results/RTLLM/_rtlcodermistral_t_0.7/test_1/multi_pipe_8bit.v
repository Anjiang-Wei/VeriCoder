```verilog
   reg [size*2-1:0] sum;
   reg [size*2-1:0] mul_out_reg;
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg [size-1:0] temp;
   integer i;
   
   always @(posedge clk, negedge rst_n) begin
      if (!rst_n) begin
         mul_en_out <= 0;
         mul_out <= 0;
         sum <= 0;
         mul_a_reg <= 0;
         mul_b_reg <= 0;
      end else begin
         mul_en_out <= mul_en_in;
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
         sum <= 0;
         mul_out_reg <= 0;
         for (i = 0; i < size; i = i + 1) begin
            temp[i] <= mul_a_reg & mul_b_reg[i];
         end
         for (i = 0; i < size; i = i + 1) begin
            sum[i*2] <= temp[i] + sum[i*2];
         end
         mul_out_reg <= sum;
         mul_out <= mul_out_reg;
      end
   end
endmodule