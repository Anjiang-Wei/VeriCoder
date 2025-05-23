module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 1'b0;
      wave <= 5'b00000;
    end
    else begin
      case (state)
        1'b0: begin
          if (wave == 5'd31) begin
            state <= 1'b1;
          end
          else begin
            wave <= wave + 1'b1;
          end
        end
        1'b1: begin
          if (wave == 5'd0) begin
            state <= 1'b0;
          end
          else begin
            wave <= wave - 1'b1;
          end
        end
      endcase
    end
  end

endmodule