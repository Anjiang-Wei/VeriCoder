```verilog
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg [size*2-1:0] temp [size-1:0];
   reg [size*2-1:0] sum [size-1:0];
   reg [size*2-1:0] mul_out_reg;
   reg [size:0] mul_en_out_reg;

   integer i;

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_en_out_reg <= 0;
      end else begin
         mul_en_out_reg <= {mul_en_out_reg[size-2:0], mul_en_in};
      end
   end

   always @(posedge clk) begin
      mul_a_reg <= mul_a;
      mul_b_reg <= mul_b;
   end

   generate
      for (i = 0; i < size; i = i + 1) begin : partial_product_gen
         assign temp[i] = (mul_b_reg[i] == 1) ? mul_a_reg : 0;
      end
   endgenerate

   generate
      for (i = 0; i < size; i = i + 1) begin : partial_sum_gen
         always @(posedge clk) begin
            if (i == 0) begin
               sum[i] <= temp[i];
            end else begin
               sum[i] <= sum[i-1] + temp[i];
            end
         end
      end
   endgenerate

   always @(posedge clk) begin
      mul_out_reg <= sum[size-1];
   end

   always @(posedge clk) begin
      if (mul_en_out_reg[size-1] == 1) begin
         mul_out <= mul_out_reg;
      end else begin
         mul_out <= 0;
      end
   end

   assign mul_en_out = mul_en_out_reg[size-1];

endmodulemodule top_module(
    input clk,
    input rst_n,
    input [7:0] mul_a,
    input [7:0] mul_b,
    input mul_en_in,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] temp [7:0];
reg [15:0] sum [7:0];
reg [15:0] mul_out_reg;
reg [8:0] mul_en_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[7:0], mul_en_in};
    end
end

always @(posedge clk) begin
    mul_a_reg <= mul_a;
    mul_b_reg <= mul_b;
end

generate
    for (i = 0; i < 8; i = i + 1) begin : partial_product_gen
        assign temp[i] = (mul_b_reg[i] == 1) ? mul_a_reg : 0;
    end
endgenerate

generate
    for (i = 0; i < 8; i = i + 1) begin : partial_sum_gen
        always @(posedge clk) begin
            if (i == 0) begin
                sum[i] <= temp[i];
            end else begin
                sum[i] <= sum[i-1] + temp[i];
            end
        end
    end
endgenerate

always @(posedge clk) begin
    mul_out_reg <=