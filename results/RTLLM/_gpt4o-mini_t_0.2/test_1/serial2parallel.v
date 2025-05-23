module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt;  // 4-bit counter to keep track of the number of received bits
    reg [7:0] shift_reg; // Shift register to hold the incoming serial data

    // Synchronous process for handling the serial to parallel conversion
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset conditions
            dout_parallel <= 8'b0;
            dout_valid <= 0;
            cnt <= 0;
            shift_reg <= 8'b0;
        end else begin
            if (din_valid) begin
                // Capture the incoming serial bit into the shift register
                shift_reg <= {shift_reg[6:0], din_serial}; // Shift left and insert new bit
                cnt <= cnt + 1; // Increment the counter

                // When 8 bits have been received
                if (cnt == 7) begin
                    dout_parallel <= shift_reg; // Assign the shift register to output
                    dout_valid <= 1; // Set valid high
                    cnt <= 0; // Reset the counter for the next set of bits
                end
            end else begin
                dout_valid <= 0; // If din_valid is not asserted, output valid is 0
            end
        end
    end

endmodule