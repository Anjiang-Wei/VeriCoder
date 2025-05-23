module serial2parallel(
    input         clk,
    input         rst_n,
    input         din_serial,
    input         din_valid,
    output reg [7:0] dout_parallel,
    output reg    dout_valid
);

    reg [3:0] cnt; // 4-bit counter to count 0 through 7

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end
        else begin
            if (din_valid) begin
                // Place the incoming serial bit to the proper bit position:
                // the first bit is stored in the MSB (bit7), second in bit6, etc.
                dout_parallel[7-cnt] <= din_serial;
                
                if (cnt == 4'd7) begin
                    // After receiving 8 bits, output is valid.
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