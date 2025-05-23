module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

    // Internal registers
    reg [3:0] data;  // Shift register to store the current parallel data
    reg [1:0] cnt;   // 2-bit counter to track the number of bits output (0 to 3)

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset
            data <= 4'b0000;    // Clear the data register
            cnt <= 2'b00;       // Reset the counter
            dout <= 1'b0;       // Clear the serial output
            valid_out <= 1'b0;  // Clear the valid output
        end else begin
            if (cnt == 2'b11) begin
                // Last bit output, prepare for new data
                data <= d;          // Load new parallel data
                dout <= d[3];       // Output MSB of the new data
                cnt <= 2'b00;       // Reset the counter
                valid_out <= 1'b1;  // Indicate valid serial output
            end else begin
                // Continue shifting data serially
                dout <= data[3];    // Output MSB of the current data
                data <= data << 1;  // Shift data left by 1 bit
                cnt <= cnt + 1;     // Increment the counter
                valid_out <= 1'b0;  // Clear the valid signal for intermediate cycles
            end
        end
    end

endmodule