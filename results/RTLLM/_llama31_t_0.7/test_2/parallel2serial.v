module parallel2serial(
    input clk,  // Clock signal used for synchronous operations.
    input rst_n,  // Reset signal. Defined as 0 for reset and 1 for reset signal inactive.
    input [3:0] d,  // 4-bit parallel data input.

    output valid_out,  // Valid signal indicating the availability of serial output.
    output dout  // Serial output representing the converted data.
);

// Counter register
reg [2:0] cnt;

// Data register to hold the parallel input for sequential bit shifting
reg [3:0] data;

// Flag to indicate when valid serial output is available
reg valid;

initial begin
    // Initialize registers with reset values
    cnt = 0;
    data = 4'd0;
    valid = 0;
end

always @(posedge clk) begin
    if (!rst_n) begin
        // On reset, increment counter and set valid flag to 0
        cnt <= cnt + 1;
        valid <= 0;
    end else begin
        case (cnt)
            3'd3: begin
                // Last bit of parallel input; update data register and reset counter
                data <= d;
                cnt <= 0;
                valid <= 1;
                dout <= data[0];  // Output most significant bit of data
            end
            default: begin
                // Increment counter and shift data register one bit to the left
                cnt <= cnt + 1;
                if (cnt == 3) begin
                    data <= {data[2], data[1], data[0], d};  // Append most significant bit of parallel input
                end else begin
                    data <= {data[2], data[1], data[0]};
                end
                valid <= 0;
            end
        endcase
    end
end

// Drive output signals
assign valid_out = valid;
assign dout = valid ? (cnt == 3 ? data[0] : data[cnt]) : 'z; // Assign most significant bit of data when valid and counter is 3, otherwise assign the current least significant bit

endmodule