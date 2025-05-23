module serial2parallel(
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    // 4-bit counter to count up to 8 serial bits
    reg [3:0] cnt;
    // shift register to assemble the 8 serial bits
    reg [7:0] shift_reg;

    // synchronous logic, active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt            <= 4'd0;
            shift_reg      <= 8'd0;
            dout_parallel  <= 8'd0;
            dout_valid     <= 1'b0;
        end else begin
            // default: no new parallel data valid
            dout_valid <= 1'b0;

            if (din_valid) begin
                // shift in new serial bit at LSB side,
                // MSB side holds the oldest bit
                shift_reg <= { shift_reg[6:0], din_serial };

                // if this is the 8th bit (cnt goes from 0..7)
                if (cnt == 4'd7) begin
                    // latch out the assembled byte
                    dout_parallel <= { shift_reg[6:0], din_serial };
                    dout_valid    <= 1'b1;
                    cnt           <= 4'd0;  // restart counting
                end else begin
                    // not yet 8 bits, just increment the counter
                    cnt <= cnt + 4'd1;
                end
            end
        end
    end

endmodule