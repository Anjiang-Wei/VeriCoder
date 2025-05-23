```verilog
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   
   wire [size-1:0] temp [2:0];
   reg [size*2-1:0] sum [2:0];
   
   integer i;
   
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_a_reg <= 0;
         mul_b_reg <= 0;
         mul_en_out <= 0;
         mul_out <= 0;
      end
      else begin
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
         mul_en_out <= mul_en_in;
         for (i=0; i<size; i=i+1) begin
            temp[0][i] <= mul_a_reg[i] & mul_b_reg[i];
            temp[1][i] <= mul_a_reg[i] & ~mul_b_reg[i];
            temp[2][i] <= ~mul_a_reg[i] & mul_b_reg[i];
         end
         for (i=0; i<2; i=i+1) begin
            sum[i] <= 0;
            for (i=0; i<size; i=i+1) begin
               sum[i] <= sum[i] + temp[i+1][i];
            end
         end
         mul_out <= sum[1] + sum[0];
      end
   end
endmodule