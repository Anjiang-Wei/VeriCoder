module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

// State machine variables
bit [3:0] state = 4'b0010; // Initialized to 011 (state 2)
bit [3:0] next_state = state; // Next state variable

always@(posedge CLK or negedge RST or IN) begin
    // Reset the state machine on reset
    if (RST) begin
        state <= 4'b0000; // Reset to initial state
        next_state <= state;
    end

    // Update the state machine based on the input and current state
    case (state)
        2: begin // State 2: Input = 1, output = 1
            if (IN == 1) begin
                state <= 4'b0011; // Transition to state 3
                next_state <= state;
            end
        end
        3: begin // State 3: Input = 0, output = 0
            if (IN == 1) begin
                state <= 4'b0100; // Transition to state 4
                next_state <= state;
            end
        end
        4: begin // State 4: Input = 0, output = 1
            if (IN == 1) begin
                state <= 4'b0010; // Transition back to state 2
                next_state <= state;
            end
        end
    end
end

// Output the match signal based on the current state and input
MATCH <= (next_state == state);

endmodule