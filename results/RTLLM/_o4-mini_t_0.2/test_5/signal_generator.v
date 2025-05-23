module signal_generator (
  input        clk,
  input        rst_n,
  output reg [4:0] wave
);

  // state = 0: counting up, state = 1: counting down
  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 1'b0;
      wave  <= 5'd0;
    end else begin
      case (state)
        1'b0: begin  // ascending
          if (wave == 5'd31) begin
            state <= 1'b1;
            wave  <= wave - 1'b1;  // start descending from 30
          end else begin
            wave <= wave + 1'b1;
          end
        end
        1'b1: begin  // descending
          if (wave == 5'd0) begin
            state <= 1'b0;
            wave  <= wave + 1'b1;  // start ascending from 1
          end else begin
            wave <= wave - 1'b1;
          end
        end
        default: begin
          state <= 1'b0;
          wave  <= 5'd0;
        end
      endcase
    end
  end

endmodule