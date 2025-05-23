module counter_12 (rst_n, clk, valid_count, out) {
  import *;

  // Reset the counter on reset signal
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out <= 4'b0000;
    end else begin
      // Increment/wrap around counter on valid count
      if (valid_count) begin
        if (out == 4'd11) begin
          out <= 4'b0000; // Wrap around to 0
        end else begin
          out <= out + 1;
        end
      end else begin
        // Pause counter when valid count is 0
        out <= 4'b0000;
      end
    end
  end
}