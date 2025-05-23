module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);
    reg [1:0] cnt;                 // 2-bit counter to count 0 to 3
    reg [3:0] data;                // Register to hold the parallel data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;          // Reset counter
            valid_out <= 1'b0;     // Reset valid output
            dout <= 1'b0;          // Reset serial output
        end else begin
            if (cnt == 2'b00) begin
                data <= d;         // Load parallel data on cnt = 0
                valid_out <= 1'b1; // Set valid output high
                dout <= data[3];   // Output the MSB
            end else if (cnt < 2'b11) begin
                valid_out <= 1'b0; // Set valid output low for clock cycles 1 and 2
                dout <= data[3 - cnt]; // Shift out the next bits
            end else begin
                valid_out <= 1'b0; // Clear valid at the end of output sequence
            end
            
            cnt <= cnt + 1'b1; // Increment counter, wraps automatically at 3 
        end
    end

endmodule