module counter_12 
(
  input rst_n,             // Active-low reset signal
  input clk,               // Clock signal
  input valid_count,       // Enable signal for counting

  output reg [3:0] out     // 4-bit output representing the current count value
);

  // Always block triggered on the rising edge of the clock or whenever the reset is asserted
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // If reset is active (low), reset the counter to 0
      out <= 4'b0000;
    end else if (valid_count) begin
      // If valid_count is active (1), increment the counter
      if (out == 4'd11) begin
        // If the current count value is 11, wrap around to 0
        out <= 4'b0000;
      end else begin
        // Otherwise, increment the counter
        out <= out + 1;
      end
    end
    // If valid_count is not active, no operation (hold current value)
  end

endmodule