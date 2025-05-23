module counter_12 
(
  input rst_n,          // Active low reset signal
  input clk,            // Clock signal
  input valid_count,    // Signal to enable counting

  output reg [3:0] out  // 4-bit output representing current count value
);

  // Always block triggered on the rising edge of the clock or negative edge of reset
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the output to 0 when reset signal is active (!rst_n)
      out <= 4'b0000;
    end else if (valid_count) begin
      // If valid_count is active, increment the counter
      if (out == 4'd11) begin
        // If the current value is 11, wrap around to 0
        out <= 4'b0000;
      end else begin
        // Otherwise, increment the counter
        out <= out + 1;
      end
    end
    // If valid_count = 0, counter remains paused (out remains unchanged)
  end

endmodule