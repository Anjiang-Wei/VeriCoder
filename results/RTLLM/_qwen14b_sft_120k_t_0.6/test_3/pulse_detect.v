module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    localparam [2:0] IDLE = 3'b000,
                     ONE = 3'b001,
                     TWO = 3'b010,
                     THREE = 3'b011,
                     LAST = 3'b100;

    reg [2:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in) begin
                        state <= ONE;
                    end
                end
                ONE: begin
                    if (data_in) begin
                        state <= ONE;
                    end else begin
                        state <= TWO;
                    end
                end
                TWO: begin
                    if (data_in) begin
                        state <= ONE;
                    end else begin
                        state <= THREE;
                    end
                end
                THREE: begin
                    if (data_in) begin
                        state <= ONE;
                    end else begin
                        state <= IDLE;
                        data_out <= 1'b1;
                    end
                end
                LAST: begin
                    data_out <= 1'b0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule