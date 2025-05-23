module signal_generator(
  input  clk,
  input  rst_n,
  output reg [4:0] wave
);

  // 1-bit state register:
  // 0: Increasing state (wave increments)
  // 1: Decreasing state (wave decrements)
  reg state;  

  // Always block triggered on positive clock edge or negative reset edge.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset condition: clear wave and state.
      wave  <= 5'd0;
      state <= 1'b0;
    end else begin
      case (state)
        1'b0: begin
          // Increasing phase: Increment wave.
          if (wave == 5'd31) begin
            // When reaching maximum (31), switch to decrementing.
            state <= 1'b1;
            wave  <= wave - 1;
          end else begin
            wave <= wave + 1;
          end
        end

        1'b1: begin
          // Decreasing phase: Decrement wave.
          if (wave == 5'd0) begin
            // When reaching minimum (0), switch to incrementing.
            state <= 1'b0;
            wave  <= wave + 1;
          end else begin
            wave <= wave - 1;
          end
        end

        default: begin
          // Default case (should not occur) to maintain known state.
          state <= 1'b0;
          wave  <= 5'd0;
        end
      endcase
    end
  end

endmodule