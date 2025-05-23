module counter_12 
(
  input         rst_n,      // Active low reset
  input         clk,        // Clock signal
  input         valid_count,// Enable signal for counting
  output reg [3:0] out      // 4-bit counter output
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
      out <= 4'b0000;                // Reset counter to zero when rst_n is low
    else if (valid_count) begin
      if (out == 4'd11)
        out <= 4'b0000;              // Wrap around if counter reaches 11
      else
        out <= out + 1;              // Increment counter
    end
    // If valid_count is 0, out remains unchanged.
  end

endmodule