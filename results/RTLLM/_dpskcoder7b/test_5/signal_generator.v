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
      case(state)
        2'b00: begin
          wave <= wave + 1;
          if (wave == 5'd31) state <= 2'b01;
        end
        2'b01: begin
          wave <= wave - 1;
          if (wave == 5'd0) state <= 2'b00;
        end
        default: begin
          state <= 2'b00;
        end
      endcase
    end
  end
endmodule