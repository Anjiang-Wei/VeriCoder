module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the counter to 0 when rst_n is low
      out <= 4'b0000;
    end else if (valid_count) begin
      // Increment the counter when valid_count is high
      if (out == 4'd11) begin
        // Wrap around to 0 when the counter reaches 11
        out <= 4'b0000;
      end else begin
        // Increment the counter
        out <= out + 1;
      end
    end
  end
endmodule