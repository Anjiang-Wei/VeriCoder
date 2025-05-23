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
      state <= 0;
      data_out <= 0;
    end else if (data_in == 1 && state == 0) begin
      // Transition to the next state when a pulse is detected
      state <= 1;
      data_out <= 1;
    end else if (state == 1 && data_in == 0) begin
      // End of a pulse, reset the state register and data_out output
      state <= 0;
      data_out <= 0;
    end
  end
}