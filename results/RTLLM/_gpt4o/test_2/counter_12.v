module counter_12 
(
  input rst_n,           // Active low reset signal
  input clk,             // Clock signal
  input valid_count,     // Signal to enable counting
  output reg [3:0] out   // 4-bit output representing the count
);

  always @(posedge clk or negedge rst_n) begin
    // Reset logic: If reset is active (!rst_n), set the counter to 0
    if (!rst_n) begin
      out <= 4'b0000;
    end
    else if (valid_count) begin
      // Check for maximum count value (11). If reached, wrap around to 0
      if (out == 4'd11) begin
        out <= 4'b0000;
      end
      else begin
        // Otherwise, increment the counter
        out <= out + 1;
      end
    end
    // If valid_count is 0, do nothing (out remains unchanged)
  end

endmodule