module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

// Always block triggered by the clock signal
always @(posedge clk or negedge rst_n) begin
    // Active low reset
    if (!rst_n) begin
        out <= 4'b0000; // Reset count to 0
    end else if (valid_count) begin
        if (out == 4'd11) begin
            out <= 4'b0000; // Wrap around to 0 if max count (11) is reached
        end else begin
            out <= out + 1; // Increment count
        end
    end
    // If valid_count is 0, the count remains unchanged
end

endmodule