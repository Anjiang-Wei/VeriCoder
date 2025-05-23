module serial2parallel(
    input         clk,
    input         rst_n,
    input         din_serial,
    input         din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    // A 4-bit counter to count serial input bits
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end
        else begin
            if (din_valid) begin
                // shift in new valid bit (first bit received will eventually appear in MSB after 8 shifts)
                dout_parallel <= {dout_parallel[6:0], din_serial};
                if (cnt == 4'd7) begin
                    // eight serial bits have now been received
                    dout_valid <= 1'b1;
                    cnt        <= 4'd0;
                end
                else begin
                    dout_valid <= 1'b0;
                    cnt        <= cnt + 4'd1;
                end
            end
            else begin
                dout_valid <= 1'b0;
            end
        end
    end

endmodule