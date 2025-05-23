module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0]dout_parallel,
    output reg dout_valid
);

// Counter to keep track of received bits
reg [3:0]cnt = 0;

always@(posedge clk or negedge rst_n) begin
    // Reset the counter on reset
    if (rst_n) begin
        cnt <= 0;
    end else begin
        // Increment the counter every din_serial input
        if (din_serial && din_valid) begin
            cnt <= cnt + 1;
        end
        // Output parallel data when 8 bits have been received
        if (cnt == 8) begin
            dout_parallel <= din_serial;
            dout_valid <= 1;
        end else begin
            dout_valid <= 0;
        end
    end
endmodule