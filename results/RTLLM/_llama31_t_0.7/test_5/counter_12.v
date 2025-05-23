module counter_12 
(
  input rst_n, // Reset signal (active low)
  input clk,   // Clock signal
  input valid_count, // Signal to enable counting

  output reg [3:0] out // 4-bit output representing the current count value
);

// Assign initial value to 'out' register
initial begin
  out = 4'b0000;
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    out <= 4'b0000; // Reset counter on active low reset signal

  else if (valid_count) begin
    if (out == 4'd11) begin // Check for maximum count value (d11)
      out <= 4'b0000; // Wrap around and reset to 0
    end
    else
      out <= out + 1; // Increment counter by 1
  end
end

endmodule