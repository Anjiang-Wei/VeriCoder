module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

reg state; // State register to control waveform generation

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // On reset, clear state and wave
    state <= 0;
    wave <= 0;
  end else begin
    case (state)
      0: begin
        // Increment wave
        if (wave < 31)
          wave <= wave + 1;
        else
          state <= 1; // Transition to decrement state
      end

      1: begin
        // Decrement wave
        if (wave > 0)
          wave <= wave - 1;
        else
          state <= 0; // Transition back to increment state
      end

      default: begin
        state <= 0; // Default state behaviour
      end
    endcase
  end
end

endmodule