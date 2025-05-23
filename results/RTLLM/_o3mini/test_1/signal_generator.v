module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  // state: 0 -> incrementing; 1 -> decrementing
  reg state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wave  <= 5'd0;
      state <= 1'b0;
    end else begin
      case (state)
        1'b0: begin // Incrementing state
          if (wave == 5'd31) begin
            state <= 1'b1;       // Switch to decrementing
            wave  <= wave - 5'd1; // Start decrementing immediately
          end else begin
            wave <= wave + 5'd1;
          end
        end
        1'b1: begin // Decrementing state
          if (wave == 5'd0) begin
            state <= 1'b0;       // Switch back to incrementing
            wave  <= wave + 5'd1; // Start incrementing immediately
          end else begin
            wave <= wave - 5'd1;
          end
        end
      endcase
    end
  end

endmodule