module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg [1:0] state;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 0;
      wave <= 0;
    end else begin
      case (state)
        0: begin
          wave <= wave + 1;
          if (wave == 31) begin
            state <= 1;
          end
        end
        1: begin
          wave <= wave - 1;
          if (wave == 0) begin
            state <= 0;
          end
        end
      endcase
    end
  end

endmodule