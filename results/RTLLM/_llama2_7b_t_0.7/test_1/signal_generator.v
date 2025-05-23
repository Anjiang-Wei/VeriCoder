module signal_generator(
  input clk,
  input rst_n,
  output reg [5:0] wave
);

  // Define registers for state and waveform
  reg [4:0] state;
  reg [5:0] wave;

  // Initialize state to 0 and wave to 0
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 0;
      wave <= 0;
    end else begin
      case (state)
        // Increment waveform when state is 0
        0: wave <= wave + 1;

        // Decrement waveform when state is 1
        1: wave <= wave - 1;

        // Reset waveform to 0 when state is 2
        2: wave <= 0;
      endcase
    end
  end

endmodule