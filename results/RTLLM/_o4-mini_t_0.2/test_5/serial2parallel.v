module serial2parallel(
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    // 4‑bit counter to count up to 8 received bits (0..7)
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset (active low)
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end
        else begin
            if (din_valid) begin
                // Shift new serial bit into MSB side:
                // first received bit -> dout_parallel[7],
                // second -> [6], ... eighth -> [0]
                dout_parallel <= { din_serial, dout_parallel[7:1] };

                // If this is the 8th valid bit (cnt==7), assert dout_valid
                if (cnt == 4'd7) begin
                    cnt        <= 4'd0;
                    dout_valid <= 1'b1;
                end
                else begin
                    cnt        <= cnt + 4'd1;
                    dout_valid <= 1'b0;
                end
            end
            else begin
                // No new serial data this cycle
                dout_valid <= 1'b0;
            end
        end
    end

endmodule