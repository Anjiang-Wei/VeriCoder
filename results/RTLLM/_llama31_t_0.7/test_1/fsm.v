module fsm(
  input IN,      // Input signal to the FSM
  output reg MATCH, // Output signal indicating a match condition
  input CLK,    // Clock signal used for synchronous operation
  input RST     // Reset signal to initialize the FSM
);

// FSM States
typedef enum {
  S0,
  S1,
  S2,
  S3,
  S4
} state_t;

reg [2:0] counter; // Counter to track sequence length

state_t curr_state, next_state; // Current and next FSM states

initial begin
  curr_state = S0;
  MATCH = 1'b0; // Reset MATCH signal on reset
end

always @(posedge RST) begin
  curr_state = S0;
  counter = 3'd0;
  MATCH = 1'b0;
end

always @(posedge CLK or posedge IN) begin
  if (curr_state == S0 && IN == 1'b1)
    next_state = S1;
  else if (curr_state == S1 && IN == 1'b0)
    next_state = S2;
  else if (curr_state == S2 && IN == 1'b0)
    next_state = S3;
  else if (curr_state == S3 && IN == 1'b1)
    next_state = S4;
  else if (curr_state == S4 && IN == 1'b1)
    next_state = S5; // Not defined in the original description
  else
    next_state = curr_state;

  if (next_state != curr_state) begin
    curr_state <= next_state;
    counter <= counter + 1;
  end

  case (curr_state)
    S0: MATCH <= 1'b0;
    S1, S2, S3:
      MATCH <= IN ? (counter == 5'd5 || counter == 9'd9) : 1'b0;
    S4: if (IN) // Last occurrence of '1' in sequence
        MATCH <= 1'b1; // Output a match only at the last occurrence of '1'
      else
        MATCH <= 1'b0;
    default: MATCH <= 1'b0; // Default case to ensure MATCH is always valid
  endcase
end

endmodule // fsm