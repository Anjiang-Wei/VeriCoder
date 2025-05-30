module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      out <= 4'b0000;
    else if (valid_count)
      if (out == 4'b1011)
        out <= 4'b0000;
      else
        out <= out + 1;
  end
endmodule