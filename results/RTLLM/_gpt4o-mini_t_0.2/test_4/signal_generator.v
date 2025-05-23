module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg state; // State control register

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 0; // Reset state to 0
      wave <= 0;  // Reset wave to 0
    end else begin
      case (state)
        0: begin
          // Increment wave
          if (wave < 31) begin
            wave <= wave + 1;
          end else begin
            // If wave reaches 31, transition to state 1
            state <= 1;
          end
        end
        1: begin
          // Decrement wave
          if (wave > 0) begin
            wave <= wave - 1;
          end else begin
            // If wave reaches 0, transition back to state 0
            state <= 0;
          end
        end
      endcase 
    end
  end

endmodule