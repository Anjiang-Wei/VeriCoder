module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;

    // State Encoding
    typedef enum reg [2:0] {
        S0, // Initial state
        S1, // State after reading '1'
        S2, // State after reading '1' → '0'
        S3, // State after reading '1' → '0' → '0'
        S4  // State after reading '1' → '0' → '0' → '1'
    } state_t;

    state_t current_state, next_state;

    // Sequential logic: State transition on clock and reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic: Next state and output logic
    always @(*) begin
        // Default assignments
        next_state = current_state;
        MATCH = 0; // Default output

        case (current_state)
            S0: begin
                if (IN) begin
                    next_state = S1; // Transition to S1 on '1'
                end
            end
            S1: begin
                if (!IN) begin
                    next_state = S2; // Transition to S2 on '0'
                end
            end
            S2: begin
                if (!IN) begin
                    next_state = S3; // Transition to S3 on '0'
                end
            end
            S3: begin
                if (IN) begin
                    next_state = S4; // Transition to S4 on '1'
                end
            end
            S4: begin
                MATCH = 1; // Match signal is set when in S4

                if (IN) begin
                    next_state = S1; // Loop back to S1 on '1'
                end else begin
                    next_state = S0; // Go back to S0 on '0'
                end
            end
            default: begin
                next_state = S0; // Default transition to S0
            end
        endcase
    end
    
endmodule