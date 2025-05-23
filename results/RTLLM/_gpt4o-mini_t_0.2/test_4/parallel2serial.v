module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data; // Register to hold parallel data
    reg [1:0] cnt;  // 2-bit counter to keep track of bit position

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset
            valid_out <= 0;
            dout <= 0;
            data <= 0;
            cnt <= 0;
        end else begin
            if (cnt == 0) begin
                // Load parallel data on first cycle and assert valid signal
                data <= d;
                valid_out <= 1;
                dout <= data[3]; // Output MSB
                cnt <= cnt + 1;  // Move to next bit
            end else if (cnt < 4) begin
                // Shift data for serial output after the first output
                dout <= data[3 - cnt]; // Output next bit in sequence
                cnt <= cnt + 1;        // Move to next bit
                valid_out <= (cnt == 3) ? 0 : 1; // Deassert valid after last bit
            end else begin
                // Reset the counter after all bits have been shifted
                cnt <= 0;
            end
        end
    end

endmodule