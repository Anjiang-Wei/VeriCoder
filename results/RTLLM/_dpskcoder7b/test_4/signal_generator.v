reg [1:0] state;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 2'b00;
      wave <= 5'b00000;
    end
    else begin
      case (state)
        2'b00: begin
          if (wave == 5'b11111)
            state <= 2'b01;
          else
            wave <= wave + 1'b1;
        end
        2'b01: begin
          if (wave == 5'b00000)
            state <= 2'b00;
          else
            wave <= wave - 1'b1;
        end
        default: begin
          state <= 2'b00;
          wave <= 5'b00000;
        end
      endcase
    end
  end
endmodule