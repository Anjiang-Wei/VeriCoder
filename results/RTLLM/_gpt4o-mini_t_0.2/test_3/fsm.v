module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;
    
    // State encoding
    typedef enum reg [2:0] {
        S0, // Initial state
        S1, // Detected 1
        S2, // Detected 10
        S3, // Detected 100
        S4  // Detected 1001
    } state_t;

    // Current and next state variables
    state_t current_state, next_state;

    // Asynchronous reset and state transition on clock edge
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0; // Reset to initial state
            MATCH <= 0;          // Output MATCH is 0 during reset
        end else begin
            current_state <= next_state; // Transition to the next state
        end
    end

    // Next state and output logic based on current state and input
    always @(*) begin
        // Default assignments
        next_state = current_state;
        MATCH = 0; // Default MATCH is 0
        
        case (current_state)
            S0: begin
                if (IN) begin
                    next_state = S1; // Transition to S1 on input 1
                end
            end
            
            S1: begin
                if (!IN) begin
                    next_state = S2; // Transition to S2 on input 0
                end
            end
            
            S2: begin
                if (!IN) begin
                    next_state = S3; // Transition to S3 on input 0
                end
            end
            
            S3: begin
                if (IN) begin
                    next_state = S4; // Transition to S4 on input 1
                end
            end
            
            S4: begin
                MATCH = 1; // Set MATCH to 1 when in state S4
                if (IN) begin
                    next_state = S1; // Loop back to S1 if input is 1
                end else begin
                    next_state = S0; // Transition back to S0 if input is 0
                end
            end
            
            default: begin
                next_state = S0; // Default back to S0 (shouldn't occur)
            end
        endcase
    end

endmodule