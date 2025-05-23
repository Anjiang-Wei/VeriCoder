module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

reg [3:0] data;     // Register to hold the parallel data
reg [1:0] cnt;      // 2-bit counter for 4 bits
reg [1:0] shift_cnt; // Counter for shifting bits out

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Resetting state
        data <= 4'b0;
        cnt <= 2'b0;
        valid_out <= 1'b0;
        dout <= 1'b0;
        shift_cnt <= 2'b0;
    end else begin
        if (cnt == 2'b00) begin
            // Load the data and set valid_out on the first cycle
            data <= d;
            valid_out <= 1'b1;
            dout <= data[3];            // Output MSB first
            cnt <= cnt + 1;             // Change to next state
            shift_cnt <= 1'b0;           // Start shifting on the next clock
        end else if (cnt < 2'b11) begin
            // Shift the bits out, valid_out is low for subsequent bits
            dout <= data[3 - cnt];      // Output the next bit as MSB to LSB
            valid_out <= 1'b0;           // Clear valid_out for subsequent bits
            cnt <= cnt + 1;             // Increment the counter
        end else begin
            // Last bit output
            dout <= data[0];            // Output the last bit (LSB)
            valid_out <= 1'b0;           // Clear valid_out after last bit
            cnt <= 2'b00;                // Reset counter for next parallel input
        end
    end
end

endmodule