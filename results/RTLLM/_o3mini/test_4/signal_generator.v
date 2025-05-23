module signal_generator(
  input  clk,
  input  rst_n,
  output reg [4:0] wave
);

  // State register: 0 for incrementing, 1 for decrementing waveform generation.
  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 1'b0;
      wave  <= 5'd0;
    end else begin
      case (state)
        1'b0: begin  // Increment state
          if (wave == 5'd31) begin
            state <= 1'b1;        // Change direction to decrement
            wave  <= wave - 1;     // Start decrementing by 1
          end else begin
            wave <= wave + 1;      // Continue incrementing
          end
        end
        1'b1: begin  // Decrement state
          if (wave == 5'd0) begin
            state <= 1'b0;        // Change direction to increment
            wave  <= wave + 1;     // Start incrementing by 1
          end else begin
            wave <= wave - 1;      // Continue decrementing
          end
        end
      endcase
    end
  end

endmodule