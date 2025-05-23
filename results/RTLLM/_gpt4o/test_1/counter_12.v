module counter_12 
(
  input rst_n,            // Reset signal (active low)
  input clk,              // Clock signal
  input valid_count,      // Signal to enable counting

  output reg [3:0] out    // 4-bit output representing the current count value
);

  // Always block triggered on the rising edge of the clock or when reset occurs
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // If reset is active (low), reset the output to 0
      out <= 4'b0000;
    end else if (valid_count) begin
      // If counting is enabled
      if (out == 4'd11) begin
        // When the counter reaches 11, wrap around to 0
        out <= 4'b0000;
      end else begin
        // Otherwise, increment the counter
        out <= out + 1;
      end
    end
    // If `valid_count` is 0, retain the current value of `out` (no action needed)
  end

endmodule