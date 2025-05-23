module serial2parallel(
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg   dout_valid
);

    // 4-bit counter to count the received serial bits
    reg [3:0] cnt;

    // Synchronous reset and data capture process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end
        else begin
            // Default output valid to 0 unless the 8th bit is received
            dout_valid <= 1'b0;
            
            // Only sample din_serial when din_valid is asserted
            if (din_valid) begin
                // Store the serial bit into the parallel output.
                // The first valid bit is stored as the MSB. 
                // Bit index is computed as (7 - cnt).
                dout_parallel[7 - cnt] <= din_serial;
                
                // Check if this is the 8th bit received
                if (cnt == 4'd7) begin
                    dout_valid <= 1'b1; // assert output valid for one cycle
                    cnt <= 4'd0;        // restart counter for next byte
                end
                else begin
                    cnt <= cnt + 4'd1;  // increment counter for next bit
                end
            end
        end
    end

endmodule