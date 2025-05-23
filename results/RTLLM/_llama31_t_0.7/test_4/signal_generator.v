module signal_generator(
  input  clk, // Clock signal used for synchronous operation.
  input  rst_n, // Active-low reset signal.
  output reg [4:0] wave // Output waveform signal representing the generated waveform.
);

// State and Waveform Generation Registers:
reg [1:0] state; // Controls the state of the waveform generation.

initial begin
  // Initialize registers with default values on startup.
  state = 2'b00;
  wave = 5'd0;
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    begin
      // Reset state and waveform registers to initial values.
      state = 2'b00;
      wave = 5'd0;
    end
  else
    begin
      case (state)
        2'b00:
          begin
            wave = wave + 1;
            if (wave == 31) state = 2'b10; // Transition to next state.
          end
        2'b10:
          begin
            wave = wave - 1;
            if (wave == 0) state = 2'b00; // Transition back to initial state.
          end
      endcase
    end
end

endmodule // signal_generator