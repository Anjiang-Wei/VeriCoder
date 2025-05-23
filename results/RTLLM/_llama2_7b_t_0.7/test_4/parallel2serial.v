module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

// Counter register
reg [3:0] cnt = 0;

// Data register
reg [4:0] data = 0;

// Valid signal
reg valid = 0;

// Reset counter on reset pulse
wire rst_cnt;
assign rst_cnt = rst_n;

always@(posedge clk or negedge rst_n) begin
    // Reset counter on reset pulse
    if (rst_n) begin
        cnt <= 0;
    end else begin
        // Update data register with parallel input on each clock cycle
        if (cnt == 3) begin
            data <= d;
            cnt <= 0;
            valid <= 1;
        end else begin
            cnt <= cnt + 1;
            valid <= 0;
            data <= data << 1; // Shift data register one bit to the left
        end
    end
end

// Output valid signal and serial output
assign valid_out = valid;
assign dout = data[3:0]; // Extract most significant bit of data register as serial output