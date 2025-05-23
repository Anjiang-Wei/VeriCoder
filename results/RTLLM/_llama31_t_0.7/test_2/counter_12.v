module counter_12 (
  input rst_n,      // Active low reset signal
  input clk,        // Clock signal
  input valid_count, // Signal to enable counting

  output reg [3:0] out // Current count value (4-bit)
);

// Assign default value to the output register on synthesis
initial begin
  out = 4'b0000;
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    // Reset counter to 0 when reset signal is active (active low)
    out <= 4'b0000;
  end else if (valid_count) begin
    // Check for wrap-around condition and increment counter if necessary
    if (out == 4'd11) begin
      out <= 4'b0000; // Reset to 0 on max count value
    end else begin
      out <= out + 1; // Increment counter by 1
    end
  end
end

// Additional code for better readability and synthesis hints
always @* begin
  // Assert that the output is valid if counting is enabled
  if (valid_count) $assert(out >= 4'b0000 && out <= 4'd11);
end