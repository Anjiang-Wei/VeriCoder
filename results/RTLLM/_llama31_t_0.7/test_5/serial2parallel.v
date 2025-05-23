module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0]dout_parallel,
    output reg dout_valid
);

// Synchronous registers
reg [3:0]cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        if (din_valid) begin
            if (cnt == 4'b1111) begin // All 8 serial data bits have been received
                dout_parallel <= {din_serial, cnt[3], cnt[2], cnt[1], cnt[0]};
                dout_valid <= 1'b1;
                cnt <= 4'b0000; // Reset the counter
            end else begin
                cnt <= cnt + 4'b0001; // Increment the counter
            end
        end
    end
end

// Output assignment
assign dout_parallel = {dout_parallel[7], dout_parallel[6], dout_parallel[5], dout_parallel[4],
                        dout_parallel[3], dout_parallel[2], dout_parallel[1], cnt};

endmodule