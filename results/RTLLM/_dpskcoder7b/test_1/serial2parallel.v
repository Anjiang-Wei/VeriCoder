reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid && cnt < 7) begin
        cnt <= cnt + 1'b1;
        dout_parallel <= {dout_parallel[6:0], din_serial};
    end else if (din_valid && cnt == 7) begin
        cnt <= 3'b000;
        dout_parallel <= {dout_parallel[6:0], din_serial};
        dout_valid <= 1'b1;
    end
end