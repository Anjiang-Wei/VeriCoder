```verilog
   reg [size-1:0] mul_a_reg;       
   reg [size-1:0] mul_b_reg;       

   reg [size*2-1:0] sum;
   reg [size*2-1:0] temp;
   
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_a_reg <= 0;
         mul_b_reg <= 0;
         sum <= 0;
         temp <= 0;
         mul_out <= 0;
         mul_en_out <= 0;
      end else begin
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;

         temp <= 0;
         sum <= 0;
         mul_en_out <= mul_en_in;
         for (integer i = 0; i < size; i = i + 1) begin
            if (mul_b[i] == 1) begin
               temp[i*2] <= mul_a_reg;
               temp[i*2+1] <= 0;
            end else begin
               temp[i*2] <= 0;
               temp[i*2+1] <= 0;
            end
         end

         for (integer i = 0; i < size; i = i + 1) begin
            sum[i*2] <= temp[i*2] + sum[i*2];
            sum[i*2+1] <= temp[i*2+1] + sum[i*2+1];
         end

         if (mul_en_out) begin
            mul_out <= sum;
         end else begin
            mul_out <= 0;
         end
      end
   end
endmodule