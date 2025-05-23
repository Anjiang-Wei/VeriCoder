module fsm(IN, MATCH, CLK, RST);
  input IN, CLK, RST;
  output reg MATCH;

  // Define the states of the FSM
  typedef enum reg [2:0] {
    S0,  // Initial state
    S1,  // Detected '1'
    S2,  // Detected '10'
    S3,  // Detected '100'
    S4,  // Detected '1001'
    S5   // Detected '10011'
  } state_type;

  state_type current_state, next_state;

  // Sequential logic for state transitions
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      current_state <= S0; // Reset to initial state
      MATCH <= 0;          // Clear MATCH output
    end else begin
      current_state <= next_state; // Update state on clock edge
    end
  end

  // Combinational logic for next state and output logic
  always @* begin
    // Default assignments
    next_state = current_state;
    MATCH = 0;

    case(current_state)
      S0: begin
        if (IN) begin
          next_state = S1;  // Move to state S1 on input '1'
        end
      end
      S1: begin
        if (~IN) begin
          next_state = S2;  // Move to state S2 on input '0'
        end
      end
      S2: begin
        if (~IN) begin
          next_state = S3;  // Move to state S3 on input '0'
        end
      end
      S3: begin
        if (IN) begin
          next_state = S4;  // Move to state S4 on input '1'
        end
      end
      S4: begin
        if (IN) begin
          MATCH = 1;        // Set MATCH on transition to S5
          next_state = S5;  // Move to state S5 on input '1'
        end else begin
          next_state = S0;  // Reset to state S0 on input '0'
        end
      end
      S5: begin
        MATCH = 1;          // Remain in S5 and keep MATCH high
        if (IN) begin
          next_state = S5;  // Stay in S5 if input is '1'
        end else begin
          next_state = S0;  // Return to S0 on input '0'
        end
      end
    endcase
  end
endmodule