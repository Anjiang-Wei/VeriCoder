module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    out <= 4'b0000; // Reset counter to 0
  else if (valid_count) begin
    if (out == 4'd11) // Check if max count is reached
      out <= 4'b0000; // Wrap around and reset to 0
    else
      out <= out + 1'b1; // Increment counter
  end
  // If valid_count is 0, out remains unchanged
end

endmodule