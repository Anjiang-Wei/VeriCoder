module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;

    // State encoding
    typedef enum reg [2:0] {
        S0, // Initial state
        S1, // Detected '1'
        S2, // Detected '10'
        S3, // Detected '100'
        S4, // Detected '1001'
        S5  // Detected '10011'
    } state_t;

    state_t current_state, next_state;

    // Sequential logic for state transition
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for state transitions and output
    always @(*) begin
        MATCH = 0; // Default MATCH is 0
        case (current_state)
            S0: begin
                if (IN) next_state = S1; // If IN is '1', move to S1
                else next_state = S0; // Stay in S0
            end
            S1: begin
                if (~IN) next_state = S2; // If IN is '0', move to S2
                else next_state = S1; // Stay in S1
            end
            S2: begin
                if (~IN) next_state = S3; // If IN is '0', move to S3
                else next_state = S1; // If IN is '1', go back to S1 (potential restart)
            end
            S3: begin
                if (IN) next_state = S4; // If IN is '1', move to S4
                else next_state = S0; // If IN is '0', go back to S0
            end
            S4: begin
                if (IN) begin
                    MATCH = 1; // Match detected
                    next_state = S5; // Move to S5
                end else begin
                    next_state = S0; // If IN is '0', go back to S0
                end
            end
            S5: begin
                MATCH = 1; // Match detected
                if (IN) begin
                    next_state = S1; // On '1', how to restart the search
                end else begin
                    next_state = S0; // On '0', return to S0
                end
            end
            default: next_state = S0; // Default case to handle any unknown states
        endcase
    end
endmodule