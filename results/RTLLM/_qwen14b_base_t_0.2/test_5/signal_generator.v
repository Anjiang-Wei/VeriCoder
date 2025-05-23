module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);
  // Define the state register
  reg [1:0] state;

  // State definitions
  localparam IDLE = 2'b00;
  localparam INCREMENT = 2'b01;
  localparam DECREMENT = 2'b10;

  // State machine logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
      wave <= 5'b0;
    end else begin
      case (state)
        IDLE: begin
          if (wave == 5'b11111) begin
            state <= DECREMENT;
          end else begin
            wave <= wave + 1;
            state <= INCREMENT;
          end
        end
        INCREMENT: begin
          wave <= wave + 1;
          if (wave == 5'b11111) begin
            state <= DECREMENT;
          end
        end
        DECREMENT: begin
          wave <= wave - 1;
          if (wave == 5'b0) begin
            state <= IDLE;
          end
        end
        default: begin
          state <= IDLE;
          wave <= 5'b0;
        end
      endcase
    end
  end
endmodule