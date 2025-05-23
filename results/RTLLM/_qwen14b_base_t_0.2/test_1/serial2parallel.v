module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);
    // Internal signals
    reg [2:0] cnt; // 3-bit counter to count up to 8
    reg [7:0] shift_reg; // 8-bit shift register to hold the data

    // Counter to count the number of valid serial inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            shift_reg <= 8'b0;
            dout_valid <= 0;
        end else if (din_valid) begin
            if (cnt < 7) begin
                cnt <= cnt + 1;
                shift_reg <= {shift_reg[6:0], din_serial}; // Shift in the new bit
            end else begin
                cnt <= 3'b0; // Reset counter after 8 bits
                shift_reg <= {shift_reg[6:0], din_serial}; // Shift in the new bit
                dout_valid <= 1; // Set valid signal
            end
        end else begin
            dout_valid <= 0; // Clear valid signal if no valid input
        end
    end

    // Assign the shift register to the parallel output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end else if (din_valid && cnt == 7) begin
            dout_parallel <= shift_reg; // Output the data when all 8 bits are received
        end
    end
endmodule