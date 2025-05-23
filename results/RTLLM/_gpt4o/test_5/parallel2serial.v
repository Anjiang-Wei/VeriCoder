module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);
    reg [3:0] data;    // Register to hold the parallel data input
    reg [1:0] cnt;     // 2-bit counter to track the bit being output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, clear all registers
            valid_out <= 0;
            dout <= 0;
            cnt <= 0;
            data <= 0;
        end else begin
            if (cnt == 2'd3) begin
                // If counter reached the last bit (3), update the parallel data
                data <= d;         // Load the new 4-bit input data
                cnt <= 0;          // Reset counter
                dout <= d[3];      // Output the MSB first
                valid_out <= 1;    // Indicate valid serial output
            end else begin
                // Otherwise, increment the counter and shift out bits
                dout <= data[2];   // Shift out the next bit (start after MSB)
                data <= {data[2:0], 1'b0}; // Shift the register left by 1 bit
                cnt <= cnt + 1;    // Increment the counter
                valid_out <= 1;    // Signal valid during shifting
            end
        end
    end
endmodule