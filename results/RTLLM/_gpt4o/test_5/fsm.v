module fsm(
    input IN,           // Input signal
    input CLK,          // Clock signal
    input RST,          // Reset signal
    output reg MATCH    // Output signal indicating a match
);

    // Define states using an enumerated style
    typedef enum reg [2:0] {
        IDLE = 3'b000,   // Initial state
        S1   = 3'b001,   // State after first 1
        S2   = 3'b010,   // State after 10
        S3   = 3'b011,   // State after 100
        S4   = 3'b100    // State after 1001
    } state_t;

    state_t current_state; // Current state register
    state_t next_state;    // Next state logic

    // Combinational logic to determine next state
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (IN)
                    next_state = S1; // Transition to S1 on `1`
                else
                    next_state = IDLE; // Remain in IDLE on `0`
            end

            S1: begin
                if (IN)
                    next_state = S1; // Stay in S1 on another `1`
                else
                    next_state = S2; // Transition to S2 on `0`
            end

            S2: begin
                if (IN)
                    next_state = S1; // Loop back on `1`
                else
                    next_state = S3; // Transition to S3 on `0`
            end

            S3: begin
                if (IN)
                    next_state = S4; // Transition to S4 on `1`
                else
                    next_state = IDLE; // Reset to IDLE on `0`
            end

            S4: begin
                if (IN)
                    next_state = S1; // Stay in match loop
                else
                    next_state = S3; // Loop back to S3 on `0`
            end

            default: next_state = IDLE; // Default state handling
        endcase
    end

    // Sequential logic to update current state
    always @(posedge CLK or posedge RST) begin
        if (RST)
            current_state <= IDLE; // Reset to IDLE state
        else
            current_state <= next_state; // Update to the next state
    end

    // Output logic for MATCH (Mealy style; depends on state and input)
    always @(posedge CLK or posedge RST) begin
        if (RST)
            MATCH <= 1'b0; // Reset MATCH to 0
        else
            case (current_state)
                S4: MATCH <= IN; // Output MATCH = 1 when reaching final state on `IN=1`
                default: MATCH <= 1'b0; // Set MATCH to 0 in other states
            endcase
    end

endmodule