module counter_12 
(
  input  rst_n,      // Reset signal (active low)
  input  clk,        // Clock signal
  input  valid_count, // Signal to enable counting

  output reg [3:0] out // 4-bit output representing the current count value
);

// Reset the counter on reset signal (rst_n) or when valid_count = 0 and out = 11'd11
always @(posedge clk or negedge rst_n)
begin
  if (!rst_n || !(valid_count && out == 11'd11))
    out <= 4'b0000;
end

// Increment the counter on valid_count signal only
always @(posedge clk)
begin
  if (valid_count && out != 11'd11)
    out <= out + 1;
end

endmodule // End of module definition