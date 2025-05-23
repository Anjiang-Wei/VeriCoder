module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);
  // Define state register
  reg [1:0] state;

  // State transition and waveform generation logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset state and wave on reset
      state <= 2'b00;
      wave <= 5'b00000;
    end else begin
      case (state)
        2'b00: begin
          // Increment wave
          if (wave < 5'd31) begin
            wave <= wave + 1;
          end else begin
            // Transition to state 1 when wave reaches 31
            state <= 2'b01;
          end
        end
        2'b01: begin
          // Decrement wave
          if (wave > 5'd0) begin
            wave <= wave - 1;
          end else begin
            // Transition back to state 0 when wave reaches 0
            state <= 2'b00;
          end
        end
        default: begin
          // Default state, should not occur
          state <= 2'b00;
        end
      endcase
    end
  end
endmodule