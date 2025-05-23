module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);
    // Internal 4-bit counter to count the number of received bits
    reg [3:0] cnt;

    // State machine to manage the process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end else begin
            if (din_valid) begin
                // Increment the counter on each valid input
                cnt <= cnt + 1;
                // Shift the parallel output left and insert the new serial bit
                dout_parallel <= {din_serial, dout_parallel[7:1]};
            end else begin
                // If no valid input, keep the counter and output as is
                cnt <= cnt;
                dout_parallel <= dout_parallel;
            end

            // Set dout_valid to 1 when 8 bits are received
            if (cnt == 8) begin
                dout_valid <= 1'b1;
            end else begin
                dout_valid <= 1'b0;
            end

            // Reset the counter after 8 bits are received
            if (cnt == 8) begin
                cnt <= 4'b0;
            end
        end
    end
endmodule