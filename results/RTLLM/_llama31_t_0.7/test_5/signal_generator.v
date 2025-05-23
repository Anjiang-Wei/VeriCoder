module signal_generator(
  input clk, // Clock signal used for synchronous operation.
  input rst_n, // Active-low reset signal. Defined as 0 for reset and 1 for reset signal inactive.
  output reg [4:0] wave // 5-bit output waveform signal representing the generated waveform.
);

// State register to control the state of the waveform generation
reg [1:0] state;

// Initialize state and waveform registers on reset
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    state <= 2'b00;
    wave <= 5'b00000;
  end else begin
    // Update waveform generation based on the current state
    case (state)
      2'b00: begin // State 0, increment waveform and transition to state 1 when waveform reaches 31
        if (wave < 31) begin
          wave <= wave + 1;
        end else begin
          state <= 2'b01; // Transition to state 1
        end
      end
      2'b01: begin // State 1, decrement waveform and transition back to state 0 when waveform reaches 0
        if (wave > 0) begin
          wave <= wave - 1;
        end else begin
          state <= 2'b00; // Transition back to state 0
        end
      end
    endcase
  end
end

endmodule