module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // Define a simple state machine with two states:
    localparam IDLE      = 1'b0,
               WAIT_FALL = 1'b1;
               
    // State register
    reg state;
    
    // State transition and output logic:
    // On a rising clock edge or when reset is asserted (active low)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: return to IDLE and clear output
            state    <= IDLE;
            data_out <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    // Wait in IDLE until we detect a rising edge.
                    if (data_in) begin
                        state    <= WAIT_FALL;
                        data_out <= 1'b0;
                    end
                    else begin
                        state    <= IDLE;
                        data_out <= 1'b0;
                    end
                end
                WAIT_FALL: begin
                    // If a falling edge occurs (data_in goes to 0),
                    // we have detected a pulse.
                    if (!data_in) begin
                        state    <= IDLE;
                        data_out <= 1'b1; // Pulse detected: assert data_out for 1 clock cycle.
                    end
                    else begin
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