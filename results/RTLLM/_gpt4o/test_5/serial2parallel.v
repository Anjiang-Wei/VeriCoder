module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Declare an internal 3-bit counter (requires 4 states: 0 to 7)
    reg [2:0] cnt;

    // Synchronous process to accumulate serial data and control outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Async reset: reset all outputs and counter
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            cnt <= 3'b0;
        end else begin
            if (din_valid) begin
                // Shift serial data into parallel register
                dout_parallel <= {dout_parallel[6:0], din_serial}; // Shift left and insert din_serial
                
                // Increment the counter
                cnt <= cnt + 1;

                // If counter reaches 7, all 8 bits have been received
                if (cnt == 3'd7) begin
                    dout_valid <= 1'b1; // Indicate that the parallel data is now valid
                end else begin
                    dout_valid <= 1'b0; // Otherwise, data is not yet valid
                end
            end else begin
                // If din_valid is not asserted, keep dout_valid low and maintain counter
                dout_valid <= 1'b0;
            end
        end
    end

endmodule