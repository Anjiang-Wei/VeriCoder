// counter_12: 4‐bit up‑counter from 0 to 11 with enable (valid_count) 
// and asynchronous active‐low reset (rst_n).

module counter_12 
(
  input        rst_n,        // active‐low reset
  input        clk,          // clock
  input        valid_count,  // count enable
  output reg [3:0] out       // 4‑bit count output
);

  // Asynchronous reset, synchronous count
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out <= 4'd0;
    end
    else if (valid_count) begin
      if (out == 4'd11)
        out <= 4'd0;           // wrap around after 11
      else
        out <= out + 4'd1;     // increment
    end
    // else: valid_count == 0, hold current value
  end

endmodule