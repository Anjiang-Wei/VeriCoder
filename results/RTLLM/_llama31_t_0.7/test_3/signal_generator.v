module signal_generator(
  input  clk, // Clock signal used for synchronous operation.
  input  rst_n, // Active-low reset signal. Defined as 0 for reset and 1 for reset signal inactive.
  output reg [4:0] wave // 5-bit output waveform signal representing the generated waveform.
);

// Register to control the state of the waveform generation
reg [1:0] state; // State register

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    // Reset, clear state and wave registers
    state <= 2'b00;
    wave <= 5'b00000;
  end else begin
    case (state)
      2'b00: begin
        // State 0, increment waveform
        if (wave < 31) begin
          wave <= wave + 1;
        end else begin
          // Transition to state 1
          state <= 2'b01;
        end
      end
      2'b01: begin
        // State 1, decrement waveform
        if (wave > 0) begin
          wave <= wave - 1;
        end else begin
          // Transition back to state 0
          state <= 2'b00;
        end
      end
    endcase
  end
end

endmodule