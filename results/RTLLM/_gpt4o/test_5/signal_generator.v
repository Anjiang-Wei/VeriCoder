module signal_generator (
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  // State register: 0 for incrementing, 1 for decrementing
  reg state;

  // Always block triggered on positive clock edge or negative reset
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Active-low reset: initialize wave and state
      wave <= 5'b00000;
      state <= 1'b0;
    end else begin
      case (state)
        1'b0: begin
          // Incrementing state
          wave <= wave + 5'b00001; // Increment wave
          if (wave == 5'b11111) // If wave reaches 31
            state <= 1'b1;       // Switch to decrementing state
        end
        1'b1: begin
          // Decrementing state
          wave <= wave - 5'b00001; // Decrement wave
          if (wave == 5'b00000) // If wave reaches 0
            state <= 1'b0;       // Switch to incrementing state
        end
      endcase
    end
  end

endmodule