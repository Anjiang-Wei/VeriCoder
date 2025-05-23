module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

// Define the state register and waveform register
reg [5:0] state; // 5-bit state register
reg [4:0] wave; // 5-bit waveform register

// Assign initial values to the state and waveform registers
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    state <= 0;
    wave <= 0;
  end else begin
    // Update the waveform based on the current state
    case (state)
      0: wave <= wave + 1; // Increment waveform by 1
      3: wave <= wave - 1; // Decrement waveform by 1
      default: wave <= wave; // Keep waveform at current value
    endcase
  end
end

// Output the generated waveform
assign waveout = wave;