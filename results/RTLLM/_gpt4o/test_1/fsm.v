module fsm (
    input IN,        // Single-bit input
    input CLK,       // Clock signal
    input RST,       // Reset signal
    output reg MATCH // Output signal indicating a match
);

    // State encoding for the FSM
    typedef enum reg [2:0] {
        S0, // Initial state / no input
        S1, // First 1 detected
        S2, // Sequence 10 detected
        S3, // Sequence 100 detected
        S4, // Sequence 1001 detected
        S5  // Sequence 10011 detected
    } state_t;
    
    state_t current_state, next_state;

    // Sequential block: Update state on positive edge of CLK or on RST
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0; // Reset state
        end else begin
            current_state <= next_state; // Transition to the next state
        end
    end

    // Combinational block: Determine the next state based on current state and input
    always @(*) begin
        // Default values
        next_state = current_state; // Stay in the same state by default
        MATCH = 0; // Default MATCH output is 0

        case (current_state)
            S0: begin
                if (IN == 1)
                    next_state = S1; // Go to S1 on input 1
            end
            S1: begin
                if (IN == 0)
                    next_state = S2; // Go to S2 on input 0
                else
                    next_state = S1; // Remain in S1 for consecutive 1s
            end
            S2: begin
                if (IN == 0)
                    next_state = S3; // Go to S3 on input 0
                else if (IN == 1)
                    next_state = S1; // Return to S1 if input is 1 (restart sequence)
            end
            S3: begin
                if (IN == 1)
                    next_state = S4; // Go to S4 on input 1
                else if (IN == 0)
                    next_state = S2; // Stay in S2 if input is 0
            end
            S4: begin
                if (IN == 1)
                    next_state = S5; // Go to S5 on input 1 (match detected)
                else if (IN == 0)
                    next_state = S2; // Restart sequence partially
            end
            S5: begin
                MATCH = 1; // Set MATCH to 1 when in state S5
                if (IN == 1)
                    next_state = S1; // Allow overlapping detection
                else if (IN == 0)
                    next_state = S2; // Restart sequence partially
            end
        endcase
    end

endmodule