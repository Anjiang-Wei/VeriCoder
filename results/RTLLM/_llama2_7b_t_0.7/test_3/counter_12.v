module counter_12 (
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

// Define the initial value of the output register
initial out = 4'b0000;

always @(posedge clk or negedge rst_n) begin
  // Reset the counter on reset signal
  if (rst_n) begin
    out <= 4'b0000;
  end else if (valid_count) begin
    // Increment the count value
    out <= out + 1;

    // Check if the count value has wrapped around
    if (out == 4'd11) begin
      out <= 4'b0000; // Wrap around to 0
    end
  end else {
    // Stop counting when valid_count is 0
    out <= 4'b0000;
  }
end