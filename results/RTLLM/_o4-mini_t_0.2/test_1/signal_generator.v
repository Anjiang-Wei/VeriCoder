module signal_generator(
  input         clk,    // system clock
  input         rst_n,  // active‐low reset
  output reg [4:0] wave // 5‐bit triangle wave output
);

  reg direction;  // 0 = count up, 1 = count down

  // On rising clock or async reset 
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Asynchronous reset: clear wave and state
      wave      <= 5'd0;
      direction <= 1'b0;
    end else begin
      case (direction)
        1'b0: begin
          // Counting up
          wave <= wave + 5'd1;
          // If we’ve reached the top, flip direction next cycle
          if (wave == 5'd31)
            direction <= 1'b1;
        end

        1'b1: begin
          // Counting down
          wave <= wave - 5'd1;
          // If we’ve reached the bottom, flip direction next cycle
          if (wave == 5'd0)
            direction <= 1'b0;
        end
      endcase
    end
  end

endmodule