module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
) {
  // Declare a register to keep track of the current state of the pulse detection process
  reg [1:0] state;

  // Initialize the state register to the initial state and set the data_out output to 0
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 2'b00;
      data_out <= 0;
    end else if (data_in && state[1]) begin
      // Check if the current state is the last state of a pulse
      if (state[0] == 1) begin
        // If it is, set data_out to 1 to indicate the end of the pulse
        data_out <= 1;
        state <= 2'b00;
      else
        // Otherwise, set data_out to 0
        data_out <= 0;
      end else begin
        // If not, set data_out to 0 and advance to the next state
        data_out <= 0;
        state <= state + 1;
      end
    end else begin
      // If the input signal is high and the current state is not the last state of a pulse, advance to the next state
      if (data_in && !state[1]) begin
        data_out <= 0;
        state <= state + 1;
      end else begin
        // If the input signal is low and the current state is not the last state of a pulse, advance to the next state
        if (!data_in && !state[1]) begin
          data_out <= 0;
          state <= state + 1;
        end
      end
    end
  end
}