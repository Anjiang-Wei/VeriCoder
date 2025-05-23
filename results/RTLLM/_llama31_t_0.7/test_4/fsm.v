// Module implementation: fsm
module fsm(
    input IN, // Input signal to the FSM.
    output reg MATCH, // Output signal indicating a match condition based on the FSM state.
    input CLK, // Clock signal used for synchronous operation.
    input RST  // Reset signal to initialize the FSM.
);

// Initialize the MATCH signal to 0 at reset.
initial
MATCH = 1'b0;

// Define states and next state logic.
typedef enum {
    S00,
    S01,
    S02,
    S03,
    S04
} fsm_state;

reg [2:0] current_state, next_state;

always @ (posedge CLK or posedge RST) begin
    if(RST) begin
        MATCH <= 1'b0;
        current_state <= S00;
    end else begin
        // Update the state based on the input signal.
        case(current_state)
            S00: begin
                next_state = (IN == 1'b1)? S01: S00;
            end
            S01: begin
                next_state = (IN == 1'b0)? S02: S01;
            end
            S02: begin
                next_state = (IN == 1'b0)? S03: S02;
            end
            S03: begin
                next_state = (IN == 1'b1)? S04: S03;
            end
            S04: begin
                MATCH <= IN; // Set the MATCH signal high when a match is found.
                if(IN == 1'b0)
                    next_state = S00;
                else
                    next_state = S01;
            end
        endcase

        current_state <= next_state;
    end
end

endmodule