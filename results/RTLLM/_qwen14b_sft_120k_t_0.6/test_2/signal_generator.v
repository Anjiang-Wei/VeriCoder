module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 2'b00;  // Reset state to 0
      wave <= 5'b00000;  // Reset wave to 0
    end else begin
      case(state)
        2'b00: begin
          if (wave == 5'd31) begin
            state <= 2'b01;  // Transition to state 1 when wave reaches 31
          end else begin
            wave <= wave + 5'd1;  // Increment wave
          end
        end
        2'b01: begin
          if (wave == 5'd0) begin
            state <= 2'b00;  // Transition to state 0 when wave reaches 0
          end else begin
            wave <= wave - 5'd1;  // Decrement wave
          end
        end
        default: begin
          state <= 2'b00;  // Default to state 0
        end
      endcase
    end
  end

endmodule