module top_module(
    input wire clk,
    input wire rst_n,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);

reg [3:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        data_out <= 4'b0;
    end
    else begin
        shift_reg <= {shift_reg[2:0], data_in};
        data_out <= shift_reg[3];
    end
end

endmodule