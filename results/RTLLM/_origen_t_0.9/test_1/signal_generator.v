module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 0;
      wave <= 0;
    end
    else begin
      case (state)
        0: begin
          if (wave == 5'd31)
            state <= 1;
          else
            wave <= wave + 1;
        end
        1: begin
          if (wave == 5'd0)
            state <= 0;
          else
            wave <= wave - 1;
        end
      endcase
    end
  end

endmodule