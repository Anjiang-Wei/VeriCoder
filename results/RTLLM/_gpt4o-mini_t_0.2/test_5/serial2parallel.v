module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt;              // 4-bit counter to track received bits
    reg [7:0] shift_reg;        // Shift register to accumulate the serial input

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'b0;         // Reset the counter
            dout_parallel <= 8'b0; // Reset the output
            dout_valid <= 1'b0;   // Reset the valid signal
            shift_reg <= 8'b0;     // Reset the shift register
        end else begin
            if (din_valid) begin
                // Shift in the serial data on each valid input
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1;    // Increment the count

                // Check if we have received 8 bits
                if (cnt == 4'd7) begin
                    dout_parallel <= shift_reg; // Outputs the received 8 bits
                    dout_valid <= 1'b1;        // Set valid signal
                    cnt <= 4'b0;               // Reset counter after 8 bits
                end else begin
                    dout_valid <= 1'b0; // Not valid until 8 bits are received
                end
            end
        end
    end

endmodule