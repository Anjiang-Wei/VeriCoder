module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
) {
  // Declare a register to keep track of the current state
  reg [1:0] state = 2'b00;

  // Initialize the state register on reset
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 2'b00;
      data_out <= 0;
    end else begin
      // Check the input pulse and transition to the next state
      case (state) is
        2'b00: begin
          if (data_in == 1) begin
            state <= 2'b01;
            data_out <= 1;
          end else begin
            state <= 2'b00;
            data_out <= 0;
          end
        end
        2'b01: begin
          if (data_in == 0) begin
            state <= 2'b00;
            data_out <= 0;
          end else begin
            state <= 2'b01;
            data_out <= 1;
          end
        end
      end
    end
  end
}