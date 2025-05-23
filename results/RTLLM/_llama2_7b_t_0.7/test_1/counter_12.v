module counter_12 (rst_n, clk, valid_count, out)
{
  input rst_n; // Reset signal (active low)
  input clk; // Clock signal
  input valid_count; // Signal to enable counting
  output reg [3:0] out; // 4-bit output representing the current count value

  // Reset the counter on reset signal
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out <= 4'b0000; // Reset to 0 on reset
    end else begin
      // Increment the count on valid count signal
      if (valid_count) begin
        if (out == 4'd11) begin // Wrap around on maximum count value
          out <= 4'b0000; // Reset to 0
        end else begin
          out <= out + 1; // Increment the output register
        end
      end else begin
        // Pause counting when valid count is 0
        out <= 4'b0000; // Freeze the counter
      end
    end
  end
}