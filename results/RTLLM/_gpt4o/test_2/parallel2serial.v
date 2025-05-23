module parallel2serial (
    input clk,             // Clock signal
    input rst_n,           // Active low reset signal
    input [3:0] d,         // 4-bit parallel data input
    output reg valid_out,  // Valid output indication
    output reg dout        // Serial output
);

    reg [2:0] cnt;         // 3-bit counter to track bit being sent
    reg [3:0] data;        // Register to hold parallel data being serialized

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers if reset signal is active
            cnt <= 3'd0;       // Initialize counter to 0
            data <= 4'd0;      // Clear data register
            dout <= 1'b0;      // Clear serial output
            valid_out <= 1'b0; // Clear valid signal
        end else begin
            if (cnt == 3'd0) begin
                // When counter is 0, load the new parallel data
                data <= d;         // Load parallel data into internal register
                dout <= d[3];      // Output the MSB of the new parallel data
                valid_out <= 1'b1; // Signal that dout is valid
                cnt <= 3'd1;       // Move to the next state
            end else if (cnt < 3'd4) begin
                // Output the rest of the bits sequentially (bits 2 -> 0)
                dout <= data[3 - cnt]; // Output the next bit of data
                cnt <= cnt + 1;        // Increment counter
                valid_out <= 1'b1;     // Signal that dout is valid
            end else begin
                // If counter reaches its max value (4), reset the process
                valid_out <= 1'b0; // No valid output at this stage
                cnt <= 3'd0;       // Reset counter for the next input
            end
        end
    end

endmodule