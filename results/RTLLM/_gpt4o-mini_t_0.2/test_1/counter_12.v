module counter_12 
(
  input rst_n,
  input clk,
  input valid_count,

  output reg [3:0] out
);

// Initialize the output register to 0
initial begin
    out = 4'b0000;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter to 0 when rst_n is active low
        out <= 4'b0000;
    end else if (valid_count) begin
        // Increment the counter if valid_count is high
        if (out == 4'd11) begin
            // Wrap around if we reach the maximum counting value
            out <= 4'b0000;
        end else begin
            out <= out + 1;
        end
    end
    // If valid_count is low, do nothing and retain the current count value
end

endmodule