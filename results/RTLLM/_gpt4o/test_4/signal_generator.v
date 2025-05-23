module signal_generator(
  input clk,            // Clock signal
  input rst_n,          // Active-low reset signal
  output reg [4:0] wave // 5-bit output waveform signal
);

  reg state; // State register: 0 for incrementing, 1 for decrementing

  // Always block for waveform generation
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Active-low reset: Initialize state and wave registers
      wave <= 5'b00000;
      state <= 1'b0;
    end else begin
      case (state)
        1'b0: begin
          // Increment state
          wave <= wave + 1;
          if (wave == 5'd31) begin
            // Switch to decrementing when wave reaches 31
            state <= 1'b1;
          end
        end
        1'b1: begin
          // Decrement state
          wave <= wave - 1;
          if (wave == 5'd0) begin
            // Switch to incrementing when wave reaches 0
            state <= 1'b0;
          end
        end
      endcase
    end
  end

endmodule