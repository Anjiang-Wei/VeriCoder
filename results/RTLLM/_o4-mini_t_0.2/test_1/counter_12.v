module counter_12 
(
  input        rst_n,        // active‐low reset
  input        clk,          // clock
  input        valid_count,  // enable counting
  output reg [3:0] out       // 4‐bit count output
);

  // Synchronous counter with active‐low reset
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out <= 4'b0000;         // reset to 0
    end else if (valid_count) begin
      if (out == 4'd11) begin
        out <= 4'b0000;       // wrap around after 11
      end else begin
        out <= out + 1;       // increment
      end
    end
    // else: valid_count == 0, hold current value
  end

endmodule