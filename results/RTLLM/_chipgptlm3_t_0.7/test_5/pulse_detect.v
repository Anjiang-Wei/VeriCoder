module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);
    reg [1:0] state;
    reg [1:0] next_state;
    parameter IDLE = 2'b00;
    parameter PULSE_DETECT = 2'b01;
    parameter PULSE_END = 2'b10;
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 0;
        end
        else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (data_in == 1'b0) begin
                        data_out <= 0;
                    end
                    else begin
                        data_out <= 0;
                        next_state <= PULSE_DETECT;
                    end
                end
                PULSE_DETECT: begin
                    if (data_in == 1'b1) begin
                        data_out <= 0;
                        next_state <= PULSE_DETECT;
                    end
                    else begin
                        data_out <= 0;
                        next_state <= PULSE_END;
                    end
                end
                PULSE_END: begin
                    if (data_in == 1'b0) begin
                        data_out <= 1;
                        next_state <= IDLE;
                    end
                    else begin
                        data_out <= 0;
                        next_state <= PULSE_DETECT;
                    end
                end
            endcase
        end
    end
endmodule