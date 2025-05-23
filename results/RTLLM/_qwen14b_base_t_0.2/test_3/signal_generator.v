module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);
  // Define state register
  reg [1:0] state;

  // State definitions
  localparam IDLE = 2'b00;
  localparam INCREMENT = 2'b01;
  localparam DECREMENT = 2'b10;

  // State machine logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset state and wave
      state <= IDLE;
      wave <= 5'b0;
    end else begin
      case (state)
        IDLE: begin
          // Increment wave
          if (wave < 5'b11111) begin
            wave <= wave + 1;
            state <= INCREMENT;
          end else begin
            state <= DECREMENT;
          end
        end
        INCREMENT: begin
          // Check if wave has reached the maximum value
          if (wave < 5'b11111) begin
            wave <= wave + 1;
          end else begin
            state <= DECREMENT;
          end
        end
        DECREMENT: begin
          // Check if wave has reached the minimum value
          if (wave > 5'b0) begin
            wave <= wave - 1;
          end else begin
            state <= IDLE;
          end
        end
        default: begin
          state <= IDLE;
        end
      endcase
    end
  end
endmodule