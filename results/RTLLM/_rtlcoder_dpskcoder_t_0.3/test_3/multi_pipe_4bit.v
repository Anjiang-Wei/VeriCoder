module top_module(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

wire [7:0] mul_out_temp;

multi_pipe_4bit multiplier(
    .clk(clk),
    .rst_n(rst_n),
    .mul_a(mul_a),
    .mul_b(mul_b),
    .mul_out(mul_out_temp)
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= mul_out_temp;
    end
end

endmodule