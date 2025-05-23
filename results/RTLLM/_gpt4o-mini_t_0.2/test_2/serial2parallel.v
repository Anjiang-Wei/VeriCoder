module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt; // 4-bit counter to count bits received
    reg [7:0] shift_reg; // Shift register to hold the serial data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            cnt <= 0;
            dout_parallel <= 8'b0;
            dout_valid <= 0;
            shift_reg <= 8'b0;
        end else begin
            if (din_valid) begin
                // Store the serial input in shift register
                shift_reg <= {shift_reg[6:0], din_serial}; // Shift left and add new data
                cnt <= cnt + 1; // Increment counter

                // Check if 8 bits have been received
                if (cnt == 7) begin
                    dout_parallel <= shift_reg; // Output the collected data
                    dout_valid <= 1; // Set output valid
                    cnt <= 0; // Reset counter for next set of data
                end else begin
                    dout_valid <= 0; // Output not valid until we have 8 bits
                end
            end else begin
                // If din_valid is not asserted, output not valid
                dout_valid <= 0;
            end
        end
    end

endmodule