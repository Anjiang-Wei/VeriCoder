module counter_12 
(
    input       rst_n,       // Active low reset
    input       clk,         // Clock input
    input       valid_count, // Enable signal for counting
    output reg [3:0] out    // 4-bit count output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;            // Reset: Counter set to 0
    else if (valid_count) begin
        if (out == 4'd11)
            out <= 4'b0000;        // Wrap around when counter reaches 11
        else
            out <= out + 1;        // Increment counter if valid_count is high
    end
    // If valid_count is low, the counter holds its value
end

endmodule