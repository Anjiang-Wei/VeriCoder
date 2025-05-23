module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);
  
  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n) // Reset condition
      out <= 4'b0000;
    else if (valid_count) // Counting condition
    begin
      if (out == 4'd11) // Wrap around condition
        out <= 4'b0000;
      else
        out <= out + 1;
    end
    else // valid_count = 0, counter stops
      out <= out;
  end
endmodule