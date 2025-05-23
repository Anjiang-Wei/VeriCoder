```verilog
  reg [1:0] state;
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 2'b00;
      wave <= 5'b00000;
    end else begin
      case (state)
        2'b00: begin
          wave <= wave + 1;
          if (wave == 31) begin
            state <= 2'b01;
          end
        end
        2'b01: begin
          wave <= wave - 1;
          if (wave == 0) begin
            state <= 2'b00;
          end
        end
      endcase
    end
  end
endmodule