module counter_12 
(
  input        rst_n,
  input        clk,
  input        valid_count,
  output reg [3:0] out
);

  // Sequential logic: reset or count on rising edge of clk
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out <= 4'b0000;
    end else if (valid_count) begin
      if (out == 4'd11)
        out <= 4'b0000;
      else
        out <= out + 1;
    end
    // else: hold current value when valid_count is 0
  end

endmodule