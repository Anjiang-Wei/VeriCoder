module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt; // 3-bit counter to track the number of bits received
    reg [7:0] shift_reg; // Shift register to store the incoming serial data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b000; // Reset counter
            shift_reg <= 8'b0; // Reset shift register
            dout_parallel <= 8'b0; // Reset parallel output
            dout_valid <= 1'b0; // Reset valid output
        end else begin
            if (din_valid) begin
                // Shift in the new serial data into the shift register
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1;

                // Check if we have received 8 bits
                if (cnt == 3'd7) begin
                    dout_parallel <= shift_reg; // Assign shift register to parallel output
                    dout_valid <= 1'b1; // Set the output valid signal
                    cnt <= 3'b000; // Reset counter for next set of data
                end else begin
                    dout_valid <= 1'b0; // Reset dout_valid until 8 bits are received
                end
            end
        end
    end
endmodule