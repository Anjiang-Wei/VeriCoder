module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg state; // 0 for incrementing, 1 for decrementing

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      state <= 0;
      wave <= 5'b00000; // Initialize wave to 0
    end else begin
      case (state)
        0: begin
          // Incrementing phase
          if (wave < 31) begin
            wave <= wave + 1; // Increment wave
          end else begin
            state <= 1; // Switch to decrementing state
          end
        end

        1: begin
          // Decrementing phase
          if (wave > 0) begin
            wave <= wave - 1; // Decrement wave
          end else begin
            state <= 0; // Switch to incrementing state
          end
        end

        default: begin
          // If an undefined state occurs, transition to state 0
          state <= 0;
          wave <= 5'b00000; // Initialize wave to 0
        end
      endcase
    end
  end

endmodule