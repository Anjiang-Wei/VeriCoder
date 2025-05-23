module counter_12 
(
  input        rst_n,        // active‑low reset
  input        clk,          // clock
  input        valid_count,  // count enable
  output reg [3:0] out       // 4‑bit counter output
);

  // Synchronous counter with active‑low asynchronous reset
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // reset asserted: go to 0
      out <= 4'b0000;
    end
    else if (valid_count) begin
      // counting enabled
      if (out == 4'd11) begin
        // wrap around when reaching 11
        out <= 4'b0000;
      end
      else begin
        // increment
        out <= out + 1;
      end
    end
    // else valid_count == 0: hold current value
  end

endmodule