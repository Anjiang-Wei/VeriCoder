module counter_12 
(
  input        rst_n,
  input        clk,
  input        valid_count,
  output reg [3:0] out
);

  // Asynchronous active‐low reset, synchronous count enable
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out <= 4'b0000;         // reset to 0 when rst_n is low
    end else if (valid_count) begin
      if (out == 4'd11)       // if we've reached 11
        out <= 4'b0000;       // wrap around to 0
      else
        out <= out + 1;       // otherwise increment
    end
    // if valid_count == 0, hold current value
  end

endmodule