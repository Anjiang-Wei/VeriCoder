module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) // Reset signal is active (active low)
    out <= 4'b0000; // Reset counter to 0

  else if (valid_count == 1 && out != 12'd11) // Increment counter when valid_count = 1 and count < maximum value
    out <= out + 1;
end

endmodule