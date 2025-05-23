module top_module(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] shift_reg;
reg [2:0] state;

always @(posedge clk) begin
    if (rst) begin
        shift_reg <= 8'b0;
        state <= 3'b000;
        data_out <= 8'b0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                shift_reg <= data_in;
                state <= 3'b001;
            end
            3'b001: begin // Shift state
                shift_reg <= {shift_reg[6:0], 1'b0};
                state <= 3'b010;
            end
            3'b010: begin // Output state
                data_out <= shift_reg[7];
                state <= 3'b000;
            end
        endcase
    end
end

endmodule