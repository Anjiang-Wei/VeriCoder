module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

// Define a counter register to track the number of bits converted
reg [3:0] cnt = 0;

// Assign the most significant bit of the parallel input to the serial output
output reg [3:0] dout = {4{1'b0}};

// Valid signal indicating the availability of serial output
output reg valid_out = 1'b0;

always@(posedge clk or negedge rst_n) begin
    // Reset the counter on reset
    if (rst_n) begin
        cnt <= 0;
    end else begin
        // If the counter is at 3, convert a new bit and update the data register
        if (cnt == 3) begin
            // Convert the most significant bit of the parallel input to serial output
            dout[0] <= d[3];
            cnt <= 0;
            valid_out <= 1;
        // Otherwise, increment the counter and shift the data register one bit left
        else begin
            cnt <= cnt + 1;
            dout <= dout [3:1] & ~dout[0];
        end
    end
end