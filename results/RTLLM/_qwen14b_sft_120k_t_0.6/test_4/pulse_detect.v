module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    reg [1:0] state;

    // State encoding: 00 - idle, 01 - start of pulse, 10 - middle of pulse, 11 - end of pulse
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00; // Reset to idle state
            data_out <= 1'b0; // No pulse detected
        end else begin
            case (state)
                2'b00: begin // Idle state
                    if (data_in) begin
                        state <= 2'b01; // Start of pulse detected
                    end
                end
                2'b01: begin // Start of pulse detected
                    if (data_in) begin
                        state <= 2'b10; // Middle of pulse detected
                    end else begin
                        state <= 2'b00; // Return to idle if pulse not detected
                    end
                end
                2'b10: begin // Middle of pulse detected
                    if (data_in) begin
                        state <= 2'b11; // End of pulse detected
                    end else begin
                        state <= 2'b00; // Return to idle if pulse not detected
                    end
                end
                2'b11: begin // End of pulse detected
                    data_out <= 1'b1; // Pulse detected
                    state <= 2'b00; // Return to idle
                end
                default: begin
                    state <= 2'b00; // Default to idle state
                end
            endcase
        end
    end

endmodule