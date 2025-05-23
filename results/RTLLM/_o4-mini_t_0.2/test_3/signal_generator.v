module signal_generator(
    input             clk,    // system clock
    input             rst_n,  // active‐low reset
    output reg [4:0]  wave    // 5‐bit triangle wave output
);

  // state = 0: ramp up; state = 1: ramp down
  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // asynchronous, active‐low reset
      state <= 1'b0;
      wave  <= 5'd0;
    end else begin
      case (state)
        1'b0: begin  // counting up
          if (wave == 5'd31) begin
            state <= 1'b1;      // switch to counting down
            wave  <= wave - 1;  // first step down
          end else begin
            wave <= wave + 1;
          end
        end

        1'b1: begin  // counting down
          if (wave == 5'd0) begin
            state <= 1'b0;      // switch to counting up
            wave  <= wave + 1;  // first step up
          end else begin
            wave <= wave - 1;
          end
        end
      endcase
    end
  end

endmodule