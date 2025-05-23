module serial2parallel(
    input               clk,
    input               rst_n,
    input               din_serial,
    input               din_valid,
    output reg  [7:0]   dout_parallel,
    output reg          dout_valid
);

    reg [3:0] cnt;

    // cnt counts how many bits have been received so far (0..7)
    // we load din_serial into dout_parallel[7-cnt] on each valid
    // when cnt hits 7 after loading, we assert dout_valid for one cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt            <= 4'd0;
            dout_parallel  <= 8'd0;
            dout_valid     <= 1'b0;
        end else begin
            // default: de‑assert dout_valid every cycle
            dout_valid <= 1'b0;

            if (din_valid) begin
                // place the incoming bit at MSB down to LSB
                dout_parallel[7 - cnt] <= din_serial;
                if (cnt == 4'd7) begin
                    // we've just received the 8th bit
                    dout_valid <= 1'b1;
                    cnt        <= 4'd0;
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end
        end
    end

endmodule