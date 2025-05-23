module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    out <= 4'b0000; // Reset counter to 0
  end
  else if (valid_count) begin
    if (out == 4'd11) begin
      out <= 4'b0000; // Wrap around to 0
    end
    else begin
      out <= out + 1'b1; // Increment counter
    end
  end
  // If valid_count is 0, the counter remains unchanged
end

endmodule