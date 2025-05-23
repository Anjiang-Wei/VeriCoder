module serial2parallel(
    input         clk,
    input         rst_n,
    input         din_serial,
    input         din_valid,
    output reg [7:0] dout_parallel,
    output reg    dout_valid
);

    // 4-bit counter to count number of received bits
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end
        else begin
            // Default dout_valid is 0 unless an output is ready
            dout_valid <= 1'b0;

            if (din_valid) begin
                // Place the serial input in the corresponding bit position.
                // The first valid received bit is stored at the most significant bit (bit7)
                // and subsequent bits fill in toward the least significant bit.
                dout_parallel[7-cnt] <= din_serial;

                // Check if this is the last bit of the 8-bit sequence.
                if (cnt == 7) begin
                    // Set valid flag since we now have a complete 8-bit data.
                    dout_valid <= 1'b1;
                    // Reset the counter for the next group.
                    cnt <= 4'd0;
                end
                else begin
                    // Increment counter until 8 bits have been received.
                    cnt <= cnt + 4'd1;
                end
            end
        end
    end

endmodule