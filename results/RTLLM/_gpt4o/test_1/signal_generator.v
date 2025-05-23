module signal_generator(
  input clk,          // Clock signal
  input rst_n,        // Active-low reset signal
  output reg [4:0] wave // 5-bit output wave signal
);

  // State register: 0 for incrementing, 1 for decrementing
  reg state;

  // Always block for synchronous operation
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Active-low reset, initialize the state and wave
      wave <= 5'd0; // Clear wave to 0
      state <= 1'b0; // Start with incrementing state
    end
    else begin
      case (state)
        1'b0: // Increment state
          if (wave == 5'd31) begin
            // If wave reaches the upper limit, switch to decrementing state
            state <= 1'b1;
          end
          else begin
            // Increment wave
            wave <= wave + 1;
          end
        1'b1: // Decrement state
          if (wave == 5'd0) begin
            // If wave reaches the lower limit, switch to incrementing state
            state <= 1'b0;
          end
          else begin
            // Decrement wave
            wave <= wave - 1;
          end
      endcase
    end
  end

endmodule