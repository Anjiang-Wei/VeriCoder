module fsm(IN, MATCH, CLK, RST);
  input  IN, CLK, RST;
  output reg MATCH;
  
  // State encoding: five states (S0 = initial state)
  // S0: no bits matched
  // S1: first bit matched (pattern "1")
  // S2: matched "10"
  // S3: matched "100"
  // S4: matched "1001"
  localparam S0 = 3'd0,
             S1 = 3'd1,
             S2 = 3'd2,
             S3 = 3'd3,
             S4 = 3'd4;
  
  reg [2:0] state, next_state;
  
  // Next state and output (Mealy) combinational logic.
  always @(*) begin
    // Default output value
    MATCH = 1'b0;
    
    case (state)
      S0: begin
        if (IN)
          next_state = S1;  // received "1"
        else
          next_state = S0;
      end
      
      S1: begin
        if (IN == 1'b0)
          next_state = S2;  // sequence "10"
        else
          next_state = S1;  // remain in S1 since a "1" is valid as first bit
      end
      
      S2: begin
        if (IN == 1'b0)
          next_state = S3;  // sequence "100"
        else
          next_state = S1;  // "101": only the last "1" can serve as a new start
      end
      
      S3: begin
        if (IN)
          next_state = S4;  // sequence "1001"
        else
          next_state = S0;
      end
      
      S4: begin
        if (IN) begin
          // "10011" matched!
          next_state = S1;  // overlapping: the last "1" can be the start of a new match
          MATCH = 1'b1;     // assert match at the exact time the final bit is received
        end else begin
          next_state = S2;  // "10010" falls back to potential "10" match (last two bits)
        end
      end
      
      default: next_state = S0;
    endcase
  end
  
  // Sequential state update; asynchronous reset sets the state to S0.
  always @(posedge CLK or posedge RST) begin
    if (RST)
      state <= S0;
    else 
      state <= next_state;
  end

endmodule