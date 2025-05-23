module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
) {
  // Define a register to keep track of the current state
  reg [1:0] state;

  always @(posedge clk or negedge rst_n) begin
    // In reset condition, set state to initial state and data_out to 0
    if (!rst_n) begin
      state <= 2'b00;
      data_out <= 0;
    end else begin
      // Check the value of data_in and transition to next state accordingly
      case (state) is
        // Data_in transitions from 0 to 1, consider it a pulse
        2'b01: state <= 2'b01; data_out <= 1;
        // Data_in transitions from 1 to 0, consider it the end of a pulse
        2'b10: state <= 2'b00; data_out <= 0;
        default: begin
          state <= state + 1;
          data_out <= 0;
        end
      end
    end
  end
}