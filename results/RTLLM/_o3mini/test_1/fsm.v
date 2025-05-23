module fsm(IN, MATCH, CLK, RST);
  input  IN, CLK, RST;
  output reg MATCH;
  
  // Internal state encoding (one-hot or binary coded)
  // Using binary coded 3-bit states.
  reg [2:0] state, next_state;
  
  // State declarations
  parameter S0 = 3'b000, // initial state
            S1 = 3'b001, // matched "1"
            S2 = 3'b010, // matched "10"
            S3 = 3'b011, // matched "100"
            S4 = 3'b100; // matched "1001" waiting for final "1"
  
  // Combinational block: determine next state and Mealy output (MATCH)
  // The output is 1 at the moment we see the last bit (IN==1) in state S4.
  // Otherwise, MATCH is 0.
  always @(*) begin
      // Default assignments: retain state and no match
      next_state = state;
      MATCH      = 1'b0;
      
      case(state)
        S0: begin
           if (IN)
              next_state = S1;
           else
              next_state = S0;
        end
        
        S1: begin
           // In state S1, the seen pattern is "1".
           // On a 0, move to S2 (pattern = "10").
           // On a 1, treat that as a possible new start.
           if (IN)
              next_state = S1;
           else
              next_state = S2;
        end
        
        S2: begin
           // Pattern so far: "10"
           // On a 0, move to S3 ("100").
           // On a 1, this "1" can be the start of the sequence.
           if (IN)
              next_state = S1;
           else
              next_state = S3;
        end
        
        S3: begin
           // Pattern so far: "100"
           // On a 1, now we have "1001" so move to S4.
           // On a 0, no valid overlap, so return to S0.
           if (IN)
              next_state = S4;
           else
              next_state = S0;
        end
        
        S4: begin
           // Pattern so far: "1001"
           // If we see a 1, we have "10011" – set MATCH to 1.
           // With overlap, the last '1' can be the starting 1 of a new sequence.
           if (IN) begin
              next_state = S1;
              MATCH      = 1'b1;
           end
           else
              next_state = S0;
        end
        
        default: begin
           next_state = S0;
           MATCH      = 1'b0;
        end
      endcase
  end
  
  // Sequential block: state update on positive edge of CLK or asynchronous RST.
  always @(posedge CLK or posedge RST) begin
     if (RST)
         state <= S0;
     else
         state <= next_state;
  end
  
endmodule