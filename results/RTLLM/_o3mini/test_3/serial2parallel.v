module serial2parallel(
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg   dout_valid
);

    // 4-bit counter to count the number of valid serial bits received
    reg [3:0] cnt;  

    always @(posedge clk) begin
        if (!rst_n) begin
            // Synchronous reset: Clear counter, output data, and valid flag
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            // Default: mark output as invalid each cycle.
            dout_valid <= 1'b0;
            
            // If a valid serial input is received, update the output register
            if (din_valid) begin
                // Place the din_serial in the output at position [7-cnt]
                // so that the first bit received becomes the MSB (bit 7)
                dout_parallel[7-cnt] <= din_serial;
                
                // Check if this was the last (8th) bit
                if (cnt == 4'd7) begin
                    // After receiving 8 bits, set the valid flag.
                    dout_valid <= 1'b1;
                    // Reset the counter for the next set of 8 serial bits.
                    cnt <= 4'd0;
                end else begin
                    // Otherwise, increment the counter
                    cnt <= cnt + 4'd1;
                end
            end
        end
    end

endmodule