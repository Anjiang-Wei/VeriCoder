module signal_generator(
  input clk,             // Clock signal
  input rst_n,           // Active-low reset signal
  output reg [4:0] wave  // 5-bit output waveform
);

  // Internal state register: 0 for incrementing, 1 for decrementing
  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the waveform and state on active-low reset
      wave <= 5'b0;  // Initialize wave to 0
      state <= 1'b0; // Initialize state to 0 (incrementing)
    end else begin
      case (state)
        1'b0: begin
          // Incrementing state
          wave <= wave + 1'b1;
          if (wave == 5'd31) begin
            state <= 1'b1; // Switch to decrementing state
          end
        end
        1'b1: begin
          // Decrementing state
          wave <= wave - 1'b1;
          if (wave == 5'd0) begin
            state <= 1'b0; // Switch to incrementing state
          end
        end
      endcase
    end
  end

endmodule