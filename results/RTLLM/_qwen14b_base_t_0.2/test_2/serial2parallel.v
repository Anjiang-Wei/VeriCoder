module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);
    // Internal signals
    reg [2:0] cnt;  // 3-bit counter to count up to 8 (0 to 7)
    reg [7:0] shift_reg;  // 8-bit shift register to hold the serial data

    // Counter and shift register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end else begin
            if (din_valid) begin
                // Increment the counter
                cnt <= cnt + 1;
                // Shift the serial data into the shift register
                shift_reg <= {shift_reg[6:0], din_serial};
                // When the counter reaches 8, set dout_parallel and dout_valid
                if (cnt == 3'b111) begin
                    dout_parallel <= shift_reg;
                    dout_valid <= 1'b1;
                    cnt <= 3'b0;  // Reset the counter
                end
            end else begin
                // If no valid data, reset dout_valid
                dout_valid <= 1'b0;
            end
        end
    end
endmodule