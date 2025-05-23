module signal_generator(
  input clk,
  input rst_n,
  output reg [5:0] wave
);

// State register to control waveform generation
reg [1:0] state;

// Waveform register to hold generated waveform
reg [5:0] wave;

// Clock signal used for synchronous operation
always @(posedge clk or negedge rst_n) begin
  // On reset, clear state and waveform registers
  if (~rst_n) begin
    state <= 0;
    wave <= 0;
  end else begin
    // Update waveform based on current state
    case (state)
      0: wave <= wave + 1; // Increment waveform by 1 when state is 0
     31: state <= 1; // Transition to state 1 when waveform reaches 31
      1: wave <= wave - 1; // Decrement waveform by 1 when state is 1
     0: state <= 0; // Transition back to state 0 when waveform reaches 0
    endcase
  end
end