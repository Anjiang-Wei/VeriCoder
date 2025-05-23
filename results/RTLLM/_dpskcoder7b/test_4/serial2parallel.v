// 4-bit counter
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        dout_parallel <= 8'b0;
        dout_valid <= 1'b0;
    end
    else if (din_valid) begin
        // Update counter
        cnt <= cnt + 1'b1;

        // Shift data into dout_parallel
        dout_parallel <= {dout_parallel[6:0], din_serial};

        // If all 8 bits have been received, set dout_valid to 1
        if (cnt == 4'b1111) begin
            dout_valid <= 1'b1;
        end
    end
end
endmodule