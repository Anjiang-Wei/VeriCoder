module counter_12 (
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

// Define the output register as a 4-bit binary number
wire [3:0] out;

// Reset the counter on reset signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000; // Reset the counter to 0
    end else begin
        // Increment the counter when valid count is high
        if (valid_count) begin
            if (out == 4'd11) begin
                out <= 4'b0000; // Wrap around to 0 when count reaches maximum value
            end else begin
                out <= out + 1; // Increment the output register
            end
        end else begin
            // Pause the counter when valid count is low
            out <= 4'b0000; // Reset the output register to 0
        end
    end
end