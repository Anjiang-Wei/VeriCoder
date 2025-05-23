module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

// Register to control the state of waveform generation
reg [1:0] state;

initial begin
  // Initialize registers on reset
  state = 2'b00;
  wave = 5'd0;
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    // Reset the state and waveform on active-low reset signal
    state <= 2'b00;
    wave <= 5'd0;
  end else begin
    case (state)
      2'b00: begin
        // Increment waveform when in state 0
        if (wave < 31) begin
          wave <= wave + 1;
        end else begin
          // Transition to state 1 on reaching maximum value
          state <= 2'b01;
        end
      end
      2'b01: begin
        // Decrement waveform when in state 1
        if (wave > 0) begin
          wave <= wave - 1;
        end else begin
          // Transition back to state 0 on reaching minimum value
          state <= 2'b00;
        end
      end
    endcase
  end
end

endmodule