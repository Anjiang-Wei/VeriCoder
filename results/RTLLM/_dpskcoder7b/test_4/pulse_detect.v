module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);
    reg [1:0] state;
    localparam IDLE = 2'b00, PULSE_EDGE = 2'b01, PULSE_END = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    if(data_in) begin
                        state <= PULSE_EDGE;
                    end
                end
                PULSE_EDGE: begin
                    if(!data_in) begin
                        state <= PULSE_END;
                    end
                end
                PULSE_END: begin
                    data_out <= 1'b1;
                    if(data_in) begin
                        state <= IDLE;
                        data_out <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule