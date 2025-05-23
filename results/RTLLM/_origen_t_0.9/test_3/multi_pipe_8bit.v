module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg mul_en_out_reg;
reg [7:0] mul_a_reg, mul_b_reg;
wire [15:0] temp [7:0];
reg [15:0] sum [7:0];
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

assign mul_en_out = mul_en_out_reg;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_temp
        assign temp[i] = (mul_b_reg[i]) ? {8'b0, mul_a_reg} << i : 16'b0;
    end
endgenerate

generate
    for (i = 0; i < 8; i = i + 1) begin : gen_sum
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                sum[i] <= 16'b0;
            else
                sum[i] <= sum[i] + temp[i];
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out_reg <= 16'b0;
    else
        mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out <= 16'b0;
    else
        mul_out <= mul_en_out_reg ? mul_out_reg : 16'b0;
end

endmodule