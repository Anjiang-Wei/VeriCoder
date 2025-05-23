module serial2parallel (
    input  clk,     // Clock signal.
    input  rst_n,   // Reset signal (active low).
    input  din_serial,  // Serial input data.
    input  din_valid,  // Validity signal for input data.
    output reg [7:0] dout_parallel,  // Parallel output data (8 bits wide).
    output reg         dout_valid      // Validity signal for the output data.
);

reg [3:0] cnt; // Counter to keep track of number of din_serial inputs received.

always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= '0;
        dout_parallel <= '0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        cnt <= cnt + 1;
        
        // If 8 serial data bits are received, load the parallel output with them.
        if (cnt == 8'd8) begin
            dout_parallel[7:0] <= {din_serial, din_serial, din_serial, din_serial, din_serial, din_serial, din_serial, din_serial};
            dout_valid <= 1'b1;
            cnt <= '0; // Reset the counter for next 8 serial data bits.
        end
    end else begin
        // If no valid input is received (din_valid == 0), reset the parallel output and validity signal.
        if (cnt != 0) begin
            dout_parallel[7:0] <= '0;
            cnt <= '0;
            dout_valid <= 1'b0;
        end
    end
end

endmodule // serial2parallel