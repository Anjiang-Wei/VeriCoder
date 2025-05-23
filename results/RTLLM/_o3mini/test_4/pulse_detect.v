module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State definitions using 1-bit encoding
    localparam IDLE = 1'b0,   // waiting for pulse start: data_in low
               HIGH = 1'b1;   // pulse started: data_in has gone high

    reg state;  // to hold the current state of the detection process

    // Sequential process: triggered by positive edge of clk or negative edge of rst_n
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition: initialize state and clear data_out
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in) begin
                        // Rising edge detected, transition to HIGH state
                        state    <= HIGH;
                        data_out <= 1'b0;
                    end else begin
                        // Remain in IDLE if data_in is 0
                        state    <= IDLE;
                        data_out <= 1'b0;
                    end
                end
                HIGH: begin
                    if (!data_in) begin
                        // Falling edge detected: complete pulse pattern 0->1->0,
                        // assert data_out for this cycle and return to IDLE
                        state    <= IDLE;
                        data_out <= 1'b1;
                    end else begin
                        // Remain in HIGH if data_in remains 1,
                        // pulse not completed yet.
                        state    <= HIGH;
                        data_out <= 1'b0;
                    end
                end
                default: begin
                    // Default fallback: return to IDLE and clear data_out
                    state    <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end
endmodule