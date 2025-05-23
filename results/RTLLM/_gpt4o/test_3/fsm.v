module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);
    // Enumerated state declaration
    typedef enum reg [2:0] {
        S0, // Initial state
        S1, // Received '1'
        S2, // Received '1, 0'
        S3, // Received '1, 0, 0'
        S4, // Received '1, 0, 0, 1'
        S5  // Received '1, 0, 0, 1, 1'
    } state_t;

    state_t current_state, next_state;

    // Synchronous logic for state transitions
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and MATCH output
    always @(*) begin
        // Default outputs
        next_state = current_state; // Hold current state by default
        MATCH = 0;                  // Default MATCH output to 0

        case (current_state)
            S0: begin
                if (IN) 
                    next_state = S1;
            end
            S1: begin
                if (!IN) 
                    next_state = S2;
                else 
                    next_state = S1; // Stay in S1 if another '1' is received
            end
            S2: begin
                if (!IN) 
                    next_state = S3;
                else 
                    next_state = S1; // Restart if '1' is received
            end
            S3: begin
                if (IN) 
                    next_state = S4;
                else 
                    next_state = S0; // Start over if sequence broken
            end
            S4: begin
                if (IN) begin
                    next_state = S5;
                    MATCH = 1; // Match detected
                end else 
                    next_state = S2; // Partially matched, rollback to S2
            end
            S5: begin
                if (!IN) 
                    next_state = S3;
                else begin
                    next_state = S1; // Optionally restart detection
                    MATCH = 1;       // Ensure MATCH is asserted for every '10011'
                end
            end
            default: next_state = S0; // Safeguard
        endcase
    end
endmodule