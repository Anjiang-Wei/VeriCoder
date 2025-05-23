module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);
  // Define state register
  reg [1:0] state;

  // State transition logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset state and wave
      state <= 2'b00;
      wave <= 5'b00000;
    end else begin
      case (state)
        2'b00: begin
          // Increment wave
          if (wave == 5'b11111) begin
            // If wave reaches 31, transition to state 1
            state <= 2'b01;
            wave <= 5'b11111; // Keep wave at 31
          end else begin
            // Otherwise, increment wave
            wave <= wave + 1;
          end
        end
        2'b01: begin
          // Decrement wave
          if (wave == 5'b00000) begin
            // If wave reaches 0, transition back to state 0
            state <= 2'b00;
            wave <= 5'b00000; // Keep wave at 0
          end else begin
            // Otherwise, decrement wave
            wave <= wave - 1;
          end
        end
      endcase
    end
  end
endmodule