module signal_generator(
  input        clk,
  input        rst_n,
  output reg [4:0] wave
);

  // direction state: 0 = counting up, 1 = counting down
  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Asynchronous reset
      state <= 1'b0;
      wave  <= 5'd0;
    end
    else begin
      case (state)
        1'b0: begin
          // increment
          wave <= wave + 5'd1;
          // if we've reached the top, switch to decrement
          if (wave == 5'd31)
            state <= 1'b1;
          else
            state <= 1'b0;
        end

        1'b1: begin
          // decrement
          wave <= wave - 5'd1;
          // if we've reached the bottom, switch to increment
          if (wave == 5'd0)
            state <= 1'b0;
          else
            state <= 1'b1;
        end

        default: begin
          // should never happen, but default back to up‐count
          state <= 1'b0;
          wave  <= 5'd0;
        end
      endcase
    end
  end

endmodule