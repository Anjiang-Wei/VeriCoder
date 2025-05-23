module top_module(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

wire [7:0] ext_mul_a;
wire [7:0] ext_mul_b;

assign ext_mul_a = { {(8-4){1'b0}}, mul_a };
assign ext_mul_b = { {(8-4){1'b0}}, mul_b };

wire [7:0] partial_product[3:0];
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : partial_product_gen
        assign partial_product[i] = (ext_mul_b[i] == 1'b1) ? ext_mul_a << i : 'd0;
    end
endgenerate

reg [7:0] sum_reg[3:0];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 4; i = i + 1) begin
            sum_reg[i] <= 'd0;
        end
    end else begin
        for (i = 0; i < 4; i = i + 1) begin
            sum_reg[i] <= sum_reg[i] + partial_product[i];
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= sum_reg[3];
    end
end

endmodule