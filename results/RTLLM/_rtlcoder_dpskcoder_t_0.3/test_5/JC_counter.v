module top_module(
    input clk,
    input rst_n,
    input [7:0] in,
    output reg [7:0] out
);

reg [7:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 8'b0;
        out <= 8'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], in};
        out <= shift_reg[7];
    end
end

endmodule