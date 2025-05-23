module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State definition using parameters
    parameter IDLE      = 1'b0,
              WAIT_FALL = 1'b1;
              
    reg state;

    // Sequential logic: state update and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1'b1) begin
                        state    <= WAIT_FALL;
                        data_out <= 1'b0;
                    end else begin
                        state    <= IDLE;
                        data_out <= 1'b0;
                    end
                end
                WAIT_FALL: begin
                    if (data_in == 1'b0) begin
                        state    <= IDLE;
                        data_out <= 1'b1;  // pulse detected at falling edge
                    end else begin
                        state    <= WAIT_FALL;
                        data_out <= 1'b0;
                    end
                end
                default: begin
                    state    <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule