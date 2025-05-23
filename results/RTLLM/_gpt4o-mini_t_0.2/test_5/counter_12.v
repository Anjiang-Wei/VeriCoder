module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

// Always block triggered on the rising edge of the clock or when reset is active
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // Reset the counter to 0
    out <= 4'b0000;
  end else if (valid_count) begin
    // Count only if valid_count is high
    if (out == 4'd11) begin
      // Wrap around when reaching the max count value
      out <= 4'b0000;
    end else begin
      // Increment the counter
      out <= out + 1;
    end
  end
  // If valid_count is low, output value stays the same
end

endmodule