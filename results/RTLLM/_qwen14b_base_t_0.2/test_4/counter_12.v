module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the counter to 0 if the reset signal is active
      out <= 4'b0000;
    end else if (valid_count) begin
      // Increment the counter if valid_count is active
      if (out == 4'd11) begin
        // Wrap around to 0 if the maximum count value is reached
        out <= 4'b0000;
      end else begin
        // Increment the counter
        out <= out + 1;
      end
    end
  end
endmodule