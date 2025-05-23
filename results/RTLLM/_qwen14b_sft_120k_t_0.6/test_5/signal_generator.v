module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

reg [1:0] state;

// State transitions for generating the triangle wave
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    state <= 2'b00; // Reset the state to 0
    wave <= 5'b00000; // Reset the wave to 0
  end
  else begin
    case (state)
      2'b00: begin // Increment state
        wave <= wave + 1'b1; // Increment wave
        if (wave == 5'd31) // Check if wave reached 31
          state <= 2'b01; // Transition to decrement state
      end
      2'b01: begin // Decrement state
        wave <= wave - 1'b1; // Decrement wave
        if (wave == 5'b00000) // Check if wave reached 0
          state <= 2'b00; // Transition back to increment state
      end
      default: state <= 2'b00; // Default to increment state
    endcase
  end
end

endmodule