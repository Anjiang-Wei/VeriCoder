module top_module(
    input clk,
    input rst_n,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    reg [7:0] shift_reg;
    reg [2:0] state;
    parameter IDLE = 3'b000;
    parameter SHIFT = 3'b001;
    parameter OUTPUT = 3'b010;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            shift_reg <= 8'b0;
            state <= IDLE;
            data_out <= 8'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (data_in != 8'b0) begin
                        shift_reg <= data_in;
                        state <= SHIFT;
                    end
                end
                SHIFT: begin
                    shift_reg <= {shift_reg[6:0], 1'b0};
                    if (shift_reg == 8'b0) begin
                        state <= OUTPUT;
                    end
                end
                OUTPUT: begin
                    data_out <= shift_reg;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule