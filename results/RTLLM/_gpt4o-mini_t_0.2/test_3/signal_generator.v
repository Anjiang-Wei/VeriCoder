module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  // State register
  reg state;

  // Always block for state and wave register updates
  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the state and wave registers
      state <= 0;
      wave <= 0;
    end else begin
      case (state)
        0: begin
          // Increment the wave signal
          if (wave < 31) begin
            wave <= wave + 1;
          end else begin
            // Transition to the next state when wave reaches 31
            state <= 1;
          end
        end
        1: begin
          // Decrement the wave signal
          if (wave > 0) begin
            wave <= wave - 1;
          end else begin
            // Transition back to the first state when wave reaches 0
            state <= 0;
          end
        end
        default: begin
          // Default case for safety (optional)
          state <= 0;
          wave <= 0;
        end
      endcase
    end
  end

endmodule