```verilog
   reg mul_en_out_reg;
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   wire [size-1:0] temp [0:size-1];
   reg [size*2-1:0] sum [0:size-1];
   reg [size*2-1:0] mul_out_reg;

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_en_out_reg <= 1'b0;
      end else begin
         mul_en_out_reg <= mul_en_in;
      end
   end

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_a_reg <= 0;
         mul_b_reg <= 0;
      end else if (mul_en_in) begin
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
      end
   end

   genvar i;
   generate
      for (i = 0; i < size; i = i + 1) begin : partial_product_gen
         assign temp[i] = (mul_b_reg[i] == 1'b1) ? mul_a_reg : 0;
      end
   endgenerate

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         sum[0] <= 0;
         for (int i = 1; i < size; i = i + 1) begin
            sum[i] <= 0;
         end
      end else if (mul_en_in) begin
         sum[0] <= temp[0];
         for (int i = 1; i < size; i = i + 1) begin
            sum[i] <= sum[i-1] + temp[i];
         end
      end
   end

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_out_reg <= 0;
      end else if (mul_en_in) begin
         mul_out_reg <= sum[size-1];
      end
   end

   assign mul_en_out = mul_en_out_reg;
   assign mul_out = (mul_en_out_reg == 1'b1) ? mul_out_reg : 0;

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
    reg [15:0] mul_out_reg;
    reg [7:0] temp [0:7];
    reg [15:0] sum [0:7];

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            mul_en_out <= mul_en_in;
            mul_out <= mul_out_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    genvar i;
    generate
        for (i = 0; i < 8;