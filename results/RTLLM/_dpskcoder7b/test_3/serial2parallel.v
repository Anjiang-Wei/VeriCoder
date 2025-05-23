reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        dout_parallel <= 0;
        dout_valid <= 0;
    end
    else if (din_valid) begin
        if (cnt < 7) begin
            cnt <= cnt + 1;
            dout_parallel <= {dout_parallel[6:0], din_serial};
        end
        else begin
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= 0;
            dout_valid <= 1;
        end
    end
    else begin
        dout_valid <= 0;
    end
end
endmodule