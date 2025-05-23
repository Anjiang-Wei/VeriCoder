module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0]dout_parallel,
    output reg dout_valid
);

// Counter to keep track of received serial data bits
localparam COUNTER_WIDTH = 4; // Number of bits in the counter
reg [COUNTER_WIDTH-1:0] cnt = 0; // Initialize counter to 0

always@(posedge clk or negedge rst_n) begin
    // Increment counter on rising edge of clock
    if (rst_n == 0 && clk == 1) begin
        cnt <= cnt + 1;
    end

    // Reset counter on reset
    else if (rst_n == 1) begin
        cnt <= 0;
    end

    // Check if enough serial data bits have been received
    if (cnt >= 8) begin
        dout_valid <= 1; // Set valid output signal to 1 when 8 bits have been received
        dout_parallel <= din_serial; // Output parallel data
        cnt <= 0; // Reset counter
    end else begin
        dout_valid <= 0; // Set invalid output signal to 0 when less than 8 bits have been received
    end
end