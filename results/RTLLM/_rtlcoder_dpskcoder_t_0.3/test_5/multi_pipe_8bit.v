wire [size-1:0] temp [size-1:0];
   wire [size*2-1:0] sum [size-1:0];
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg [size*2-1:0] mul_out_reg;
   reg [size-1:0] mul_en_out_reg;
   integer i, j;

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         mul_en_out_reg <= 0;
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

   always @(*) begin
      for (i = 0; i < size; i = i + 1) begin
         temp[i] = mul_a_reg & (1 << i);
      end
   end

   always @(*) begin
      for (i = 0; i < size; i = i + 1) begin
         sum[i] = 0;
         for (j = 0; j < size; j = j + 1) begin
            sum[i] = sum[i] + (temp[j] << i) * (mul_b_reg[j] << i);
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

   always @(*) begin
      if (mul_en_out_reg[size-1]) begin
         mul_en_out = 1;
         mul_out = mul_out_reg;
      end else begin
         mul_en_out = 0;
         mul_out = 0;
      end
   end

endmodulemodule top_module (
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
    reg [7:0] temp [7:0];
    reg [15:0] sum [7:0];
    integer i, j;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_en_out <= 0;
            mul_out <= 0;
        end else begin
            mul_en_out <= mul_en_in;
            mul_out <= mul_out_reg;
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

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            temp[i] = mul_a_reg & (1 << i);
        end
    end

    always @(*) begin
        for (