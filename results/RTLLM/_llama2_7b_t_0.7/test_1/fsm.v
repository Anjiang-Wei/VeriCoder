module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

// Define the states of the FSM
localparam [2:0] STATE = 3'b001; // Initial state
always @* begin
  // State machine logic
  case (STATE)
    // Transition to state 1 when IN = 1 and RST = 0
    IN && !RST => STATE <= STATE + 1;
    
    // Transition to state 2 when IN = 0 and RST = 0
    !IN && !RST => STATE <= STATE - 1;
    
    // Output MATCH based on the current state
    MATCH = (STATE == 1) ? 1 : 0;
endcase

endmodule