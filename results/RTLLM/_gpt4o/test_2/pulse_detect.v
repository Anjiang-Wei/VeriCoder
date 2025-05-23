module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State definitions for the state machine
    typedef enum logic [1:0] {
        IDLE        = 2'b00, // Waiting for a rising edge of data_in
        RISE_DETECT = 2'b01, // Detected rising edge (0 -> 1)
        FALL_DETECT = 2'b10  // Detected falling edge (1 -> 0)
    } state_t;

    state_t current_state, next_state; // Current and next states

    // Sequential block for state transitions
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            current_state <= IDLE; // Reset to IDLE state
        else
            current_state <= next_state; // Update state on clock edge
    end

    // Combinational block for next state logic
    always @(*) begin
        // Default values
        next_state = current_state;
        data_out = 1'b0;

        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = RISE_DETECT; // Transition to RISE_DETECT on rising edge (0 -> 1)
            end

            RISE_DETECT: begin
                if (data_in == 1'b0)
                    next_state = FALL_DETECT; // Transition to FALL_DETECT on falling edge (1 -> 0)
            end

            FALL_DETECT: begin
                if (data_in == 1'b0) begin
                    data_out = 1'b1;   // Pulse detected, set data_out
                    next_state = IDLE; // Go back to IDLE state
                end else begin
                    next_state = RISE_DETECT; // Account for spurious glitches
                end
            end
        endcase
    end

endmodule