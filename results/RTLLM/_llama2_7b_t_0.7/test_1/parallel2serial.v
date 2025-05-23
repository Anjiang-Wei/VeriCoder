module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

// Counter register
reg cnt = 0;

// Valid signal
reg valid = 0;

// Data register
wire [3:0] data;

always@(posedge clk or negedge rst_n) begin
    // Reset counter on reset
    if (rst_n) begin
        cnt <= 0;
        valid <= 0;
    end else begin
        // Update counter on each cycle
        if (cnt == 3) begin
            // Update data register and set valid signal
            data <= d;
            valid <= 1;
            cnt <= 0;
        end else begin
            // Increment counter and shift data register
            cnt <= cnt + 1;
            data <= data << 1;
        end
    end
end

// Output signals
assign valid_out = valid;
assign dout = data;