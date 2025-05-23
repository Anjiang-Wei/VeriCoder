module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg [1:0] state;
  parameter IDLE = 2'b00, INC = 2'b01, DEC = 2'b10;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
      wave <= 5'b00000;
    end
    else begin
      case (state)
        IDLE: begin
          wave <= wave + 1;
          if (wave == 5'b11111)
            state <= INC;
        end
        INC: begin
          wave <= wave + 1;
          if (wave == 5'b11111)
            state <= DEC;
        end
        DEC: begin
          wave <= wave - 1;
          if (wave == 5'b00000)
            state <= IDLE;
        end
      endcase
    end
  end
endmodule