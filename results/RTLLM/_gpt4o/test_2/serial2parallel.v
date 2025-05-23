module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);
    // Declare the 4-bit counter
    reg [2:0] cnt; // A 3-bit counter since 2^3 = 8

    // Sequential always block triggered by clock and reset signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all signals
            cnt <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end else if (din_valid) begin
            // Shift din_serial into dout_parallel
            dout_parallel <= {dout_parallel[6:0], din_serial};

            if (cnt == 3'd7) begin
                // If 8 bits have been received, the output is valid
                dout_valid <= 1'b1;
                cnt <= 3'b0; // Reset counter
            end else begin
                // Otherwise, keep counting but output is not valid yet
                dout_valid <= 1'b0;
                cnt <= cnt + 1'b1;
            end
        end else begin
            // If din_valid is not set, make output invalid
            dout_valid <= 1'b0;
        end
    end
endmodule