module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);
    
    reg [3:0] cnt; // 4-bit counter to count the number of valid bits received

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0; // Reset the parallel output
            dout_valid <= 1'b0;     // Reset the valid signal
            cnt <= 4'b0;            // Reset the counter
        end else begin
            if (din_valid) begin
                if (cnt < 8) begin
                    dout_parallel <= {dout_parallel[6:0], din_serial}; // Shift in the new bit
                    cnt <= cnt + 1; // Increment the counter
                end
                // Set dout_valid when we have received 8 bits
                if (cnt == 7) begin
                    dout_valid <= 1'b1; // Set dout_valid to 1 after receiving 8 bits
                end 
            end else begin
                dout_valid <= 1'b0; // If din_valid is not asserted, dout_valid is 0
            end
        end
    end

    // Logic to reset dout_valid after reading the parallel data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_valid <= 1'b0; // Reset dout_valid on reset
        end else begin
            // Clear dout_valid after the data has been read
            if (dout_valid && cnt == 8) begin
                dout_valid <= 1'b0; // Reset dout_valid after outputting the valid data
                cnt <= 4'b0; // Reset the counter
                dout_parallel <= 8'b0; // Optionally reset output data if required
            end
        end
    end

endmodule