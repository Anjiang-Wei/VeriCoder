module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Internal signal for 4-bit counter to count the number of serial data received
    reg [3:0] cnt;

    // Synchronous process driven by the clock signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all outputs and internal states
            cnt <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            if (din_valid) begin
                // Shift the serial data into the parallel register
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // Increment the counter and check if 8 bits are received
                if (cnt == 4'd7) begin
                    // Output is valid after 8 bits are received
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;  // Reset counter for the next set of input
                end else begin
                    dout_valid <= 1'b0; // Output not valid until 8 bits are received
                    cnt <= cnt + 4'd1;
                end
            end
        end
    end

endmodule