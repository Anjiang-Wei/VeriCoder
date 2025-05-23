module top_module(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] shift_reg [0:7];
reg [2:0] index;

always @(posedge clk) begin
    if (reset) begin
        index <= 0;
        data_out <= 0;
        for (int i = 0; i < 8; i = i + 1) begin
            shift_reg[i] <= 0;
        end
    end else begin
        shift_reg[index] <= data_in;
        index <= index + 1;
        if (index == 8) begin
            index <= 0;
            data_out <= shift_reg[7];
        end
    end
end

endmodule