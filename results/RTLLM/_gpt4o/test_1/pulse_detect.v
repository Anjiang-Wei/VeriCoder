module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // Define state encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00, // Waiting for pulse to begin
        HIGH  = 2'b01, // Detected high level (1)
        FALL  = 2'b10  // Transition detected from high (1) to low (0)
    } state_t;

    state_t state, next_state;

    // Sequential logic: State transitions on clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE; // Reset state to IDLE
        else
            state <= next_state; // Transition to next state
    end

    // Combinational logic: Define next states and data_out
    always @(*) begin
        // Defaults
        next_state = state; // Hold the current state by default
        data_out = 1'b0;    // Default output is 0

        // State Machine for pulse detection
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH; // Start of a pulse
            end
            HIGH: begin
                if (!data_in)
                    next_state = FALL; // Transition from 1 to 0
            end
            FALL: begin
                next_state = IDLE;  // End of pulse, go back to IDLE
                data_out = 1'b1;    // Output a pulse indication
            end
        endcase
    end

endmodule