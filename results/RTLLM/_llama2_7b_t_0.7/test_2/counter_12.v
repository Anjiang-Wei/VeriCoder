module counter_12 (
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

// Define the initial value of the output register
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    out <= 4'b0000; // Reset to 0 on reset
  end else if (valid_count) begin
    if (out == 4'd11) begin // Check for wrap-around
      out <= 4'b0000; // Wrap around and reset to 0
    } else {
      out <= out + 1; // Increment on valid count
    }
  end
end