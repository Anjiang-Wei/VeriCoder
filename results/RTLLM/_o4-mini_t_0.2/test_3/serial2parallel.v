module serial2parallel(
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    // 4‐bit counter to count incoming serial bits
    reg [3:0] cnt;
    // internal shift register
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // asynchronous reset
            cnt           <= 4'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            // by default clear dout_valid each cycle
            dout_valid <= 1'b0;

            if (din_valid) begin
                // load the incoming serial bit into the proper position
                // first bit goes to MSB (bit 7), next to bit 6, … last to bit 0
                shift_reg[7 - cnt] <= din_serial;

                if (cnt == 4'd7) begin
                    // we've just received the 8th bit
                    // form the parallel word: bits [7:1] are in shift_reg, bit0 is din_serial
                    dout_parallel <= { shift_reg[7:1], din_serial };
                    dout_valid    <= 1'b1;
                    cnt           <= 4'd0;
                end else begin
                    // increment counter until we hit 7
                    cnt <= cnt + 4'd1;
                end
            end
        end
    end

endmodule