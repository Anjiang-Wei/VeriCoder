module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

// Define the states of the FSM
wire [3:0] state = 4'b0010; // Initialize in state 4 (match=0)

always @(posedge CLK or posedge RST) begin
  // Reset the state machine on reset
  if (RST) begin
    state <= 4'b0010; // Restore initial state
  end else begin
    // Update the state based on the input and previous state
    case (state)
      4'b0010: // Input = 1, previous state = 1
        if (IN) begin
          state <= 4'b0011; // Transition to state 5 (match=1)
        end else begin
          state <= 4'b0010; // Stay in state 4
        end
      4'b0011: // Input = 0, previous state = 1
        if (IN && IN != state[3]) begin
          state <= 4'b0010; // Transition to state 4
        end else begin
          state <= 4'b0011; // Stay in state 5
        end
      default: begin
        MATCH = 0; // Set match to 0 if not in a valid state
      end
    endcase
  end
end

// Output the match signal
MATCH <= state[3];

endmodule