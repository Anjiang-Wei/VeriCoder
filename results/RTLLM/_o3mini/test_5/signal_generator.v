module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  // State register: 0 indicates counting up, 1 indicates counting down.
  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Active-low reset: clear both wave and state.
      wave  <= 5'd0;
      state <= 1'b0;
    end
    else begin
      case (state)
        1'b0: begin
          // Counting up
          wave <= wave + 5'd1;
          if (wave == 5'd31)
            state <= 1'b1; // Switch direction to counting down when wave reaches 31
        end
        1'b1: begin
          // Counting down
          wave <= wave - 5'd1;
          if (wave == 5'd0)
            state <= 1'b0; // Switch direction back to counting up when wave reaches 0
        end
        default: begin
          // Default case is not really needed; included for completeness.
          wave  <= 5'd0;
          state <= 1'b0;
        end
      endcase
    end
  end

endmodule