module top_module(
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] shift_reg;
reg [2:0] count;

always @(posedge clk) begin
    if (rst) begin
        shift_reg <= 8'b0;
        count <= 3'b0;
        data_out <= 8'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], data_in};
        count <= count + 1;
        if (count == 3'b111) begin
            data_out <= shift_reg[7];
            shift_reg <= {shift_reg[6:0], 1'b0};
            count <= 3'b0;
        end
    end
end

endmodule