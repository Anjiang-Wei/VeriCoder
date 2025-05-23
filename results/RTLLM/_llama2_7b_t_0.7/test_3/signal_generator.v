module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

// State register to control waveform generation
reg [1:0] state;

// Waveform register to hold generated waveform
reg [5:0] wave;

// Clock signal for synchronous operation
assign clk = input_clk;

// Reset signal for active-low reset
assign rst_n = input_rst_n;

// Update state and waveform registers on clock edge
always @(posedge clk or negedge rst_n) begin
  // Clear state register on reset
  if (!rst_n) begin
    state <= 0;
  end else begin
    // Update state based on current waveform value
    case (wave) matches({
      1'b0: state <= state + 1; // Increment waveform
      1'b1: state <= state - 1; // Decrement waveform
      default: state <= 0; // Reset to 0 if invalid waveform value
    })
  end

  // Update waveform register based on state
  wave <= state;
end

// Output waveform signal
output wire [4:0] wave;

endmodule