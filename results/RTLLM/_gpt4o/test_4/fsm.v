module fsm (
    input IN,          // Input signal to the FSM
    input CLK,         // Clock signal for synchronous operation
    input RST,         // Reset signal to initialize the FSM
    output reg MATCH   // Output signal indicating a match condition
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,   // Initial state
        S1   = 3'b001,   // Detected '1'
        S2   = 3'b010,   // Detected '10'
        S3   = 3'b011,   // Detected '100'
        S4   = 3'b100,   // Detected '1001'
        S5   = 3'b101    // Detected '10011'
    } state_t;

    state_t current_state, next_state;

    // Sequential state transition logic (triggered on clock's rising edge or reset)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= IDLE;   // Reset the state to IDLE
            MATCH <= 0;             // Reset the match signal to 0
        end else begin
            current_state <= next_state;  // Update state
        end
    end

    // Combinational next-state and output logic
    always @(*) begin
        // Default values for next state and output
        next_state = current_state;
        MATCH = 0;

        case (current_state)
            IDLE: begin
                if (IN) 
                    next_state = S1;   // Transition to S1 on input '1'
                else
                    next_state = IDLE; // Stay in IDLE on input '0'
            end

            S1: begin
                if (!IN) 
                    next_state = S2;   // Transition to S2 on input '0'
                else
                    next_state = S1;   // Remain in S1 on consecutive '1's
            end

            S2: begin
                if (!IN)
                    next_state = S3;   // Transition to S3 on second input '0'
                else
                    next_state = S1;   // Restart sequence on input '1'
            end

            S3: begin
                if (IN) 
                    next_state = S4;   // Transition to S4 on input '1'
                else
                    next_state = IDLE; // Restart on input '0'
            end

            S4: begin
                if (IN) begin
                    next_state = S5;   // Transition to S5 on input '1'
                    MATCH = 1;         // Set MATCH = 1
                end else
                    next_state = S2;   // Loop detection: return to S2
            end

            S5: begin
                MATCH = 1;             // Maintain MATCH = 1 upon detection
                if (!IN)
                    next_state = S3;   // Loop detection: restart at '100'
                else
                    next_state = S1;   // Return to S1 on input '1'
            end

            default: next_state = IDLE; // Default state is IDLE
        endcase
    end
endmodule