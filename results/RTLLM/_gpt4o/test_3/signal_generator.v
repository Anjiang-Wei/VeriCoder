module signal_generator(
  input clk,          // Clock signal
  input rst_n,        // Active-low reset signal
  output reg [4:0] wave // 5-bit triangle waveform output
);
  
  reg state; // State register: 0 = incrementing, 1 = decrementing

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset condition: initialize the waveform to 0 and the state to 0
      wave <= 5'd0;
      state <= 1'b0;
    end else begin
      case (state)
        1'b0: begin
          // Incrementing state
          if (wave == 5'd31) begin
            // If the waveform reaches maximum (31), switch to decrementing
            state <= 1'b1;
          end else begin
            wave <= wave + 5'd1; // Increment the waveform
          end
        end
        1'b1: begin
          // Decrementing state
          if (wave == 5'd0) begin
            // If the waveform reaches minimum (0), switch to incrementing
            state <= 1'b0;
          end else begin
            wave <= wave - 5'd1; // Decrement the waveform
          end
        end
        default: begin
          // Default state (shouldn't be reached in a clean design)
          state <= 1'b0;
          wave <= 5'd0;
        end
      endcase
    end
  end

endmodule