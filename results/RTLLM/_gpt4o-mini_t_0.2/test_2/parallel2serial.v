module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);
    reg [3:0] data;   // Register to hold the input data
    reg [1:0] cnt;    // Counter to track the bit output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;  // Reset the counter
            valid_out <= 0; // Reset valid_out
            dout <= 0;      // Reset dout
        end else begin
            if (cnt == 2'b00) begin
                data <= d;  // Load new parallel data on first cycle
                valid_out <= 1; // Set valid signal
                dout <= data[3]; // Output the MSB (data[3])
                cnt <= cnt + 1; // Increment the counter
            end else if (cnt < 2'b11) begin
                dout <= data[3 - cnt]; // Shift out the bits
                valid_out <= 0; // Clear valid signal for subsequent bits
                cnt <= cnt + 1; // Increment the counter
            end else begin
                dout <= data[0]; // Output the last remaining bit
                valid_out <= 0; // Clear valid signal after the last bit
                cnt <= 0; // Reset counter for the next cycle
            end
        end
    end

endmodule