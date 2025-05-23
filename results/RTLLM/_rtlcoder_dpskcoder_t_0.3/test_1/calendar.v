module top_module(
    input clk,
    input reset,
    input [7:0] data,
    output reg [7:0] q
);

reg [7:0] shift_reg [0:7];
reg [2:0] index;

always @(posedge clk) begin
    if (reset) begin
        index <= 0;
        q <= 0;
    end else begin
        shift_reg[index] <= data;
        index <= index + 1;
        if (index == 8) begin
            index <= 0;
            q <= shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3] + shift_reg[4] + shift_reg[5] + shift_reg[6] + shift_reg[7];
        end
    end
end

endmodule