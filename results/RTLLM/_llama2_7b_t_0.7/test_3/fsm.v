module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

// Define the states of the FSM
wire [3:0] state;
always @* begin
  // On reset, set the state to IDLE
  if (RST) begin
    state <= {4'b0001};
  end else {
    // On clock edge, transition to next state based on input
    case (IN) {
      4'b0000: state <= {4'b0001}; break; // Input = 0, output MATCH = 0
      4'b0010: state <= {4'b0011}; break; // Input = 1, output MATCH = 1
      default: state <= {4'b0000}; break; // Otherwise, set MATCH to 0
    }
  }
end

// Output the match signal based on the current state
assign MATCH = (state == {4'b0011});

endmodule