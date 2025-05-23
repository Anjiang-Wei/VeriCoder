module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [4:0] state; // State of the FSM (up to 5 states)

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 0; // Reset the FSM state when RST is active
        MATCH <= 0;
    end else begin
        case(state)
            0: // Initial state (no sequence detected yet)
                if(IN) state <= 1; // Move to next state if IN=1
                else state <= 0; // Reset to initial state if IN=0

            1: // Sequence starts with 1, 0
                if(!IN && !state[3]) begin // Check for sequence 1, 0, 0, 1, 1
                    state <= 2;
                end else if(IN) state <= 2; // Move to next state if IN=1
                else state <= 0;

            2: // Sequence 1, 0, 0, 1, 1 detected
                if(!IN && !state[3]) begin // Check for sequence 1, 0, 0, 1, 1, 0, 0, 1, 1
                    state <= 3;
                end else if(IN) state <= 4; // Move to next state if IN=1
                else state <= 0;

            3: // Sequence 1, 0, 0, 1, 1, 0, 0 detected
                MATCH <= 1; // Set MATCH signal high for this sequence
                state <= 0; // Reset to initial state

            4: // Sequence 1, 0, 0, 1, 1, 0 detected (end of sequence)
                if(IN) begin // Move to final state if IN=1
                    MATCH <= 1;
                    state <= 5;
                end else state <= 3; // Reset to previous state if IN=0

            5: // Final state (sequence 1, 0, 0, 1, 1, 0, 0, 1, 1 detected)
                MATCH <= 1; // Set MATCH signal high for this sequence
        endcase
    end
end

endmodule