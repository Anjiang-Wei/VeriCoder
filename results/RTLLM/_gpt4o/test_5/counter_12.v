module counter_12 
(
  input rst_n,                // Active low reset signal
  input clk,                  // Clock signal
  input valid_count,          // Signal to enable counting
  output reg [3:0] out        // 4-bit output for the current count value
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the counter to 0 when rst_n is low (active low reset)
      out <= 4'b0000;
    end else if (valid_count) begin
      // Only increment the counter when valid_count is 1
      if (out == 4'd11) begin
        // Wrap around when reaching the maximum value of 11
        out <= 4'b0000;
      end else begin
        // Increment the counter
        out <= out + 1;
      end
    end
    // If valid_count is 0, the counter holds its current value
  end

endmodule