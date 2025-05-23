module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg [1:0] state;

  // State register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 2'b00;
    end
    else begin
      case (state)
        2'b00: if (wave == 5'b00000) state <= 2'b01;
        2'b01: state <= 2'b10;
        2'b10: if (wave == 5'b11111) state <= 2'b11;
        2'b11: state <= 2'b00;
      endcase
    end
  end

  // Waveform register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      wave <= 5'b00000;
    end
    else begin
      case (state)
        2'b00: wave <= wave + 1'b1;
        2'b10: wave <= wave - 1'b1;
        default: ;
      endcase
    end
  end

endmodule