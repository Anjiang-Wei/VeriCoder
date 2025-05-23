module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

// Internal registers: cnt is a 2-bit counter; data holds the 4-bit shift register;
// valid is asserted when the MSB from d is available on dout.
reg [1:0] cnt;
reg [3:0] data;
reg       valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronously clear the counter, shift register, and valid flag.
        cnt   <= 2'd0;
        data  <= 4'b0;
        valid <= 1'b0;
    end else begin
        // If counter reaches 3, it means that the last bit of the current cycle
        // has been output. Reload the shift register with new parallel data,
        // clear the counter, and indicate valid new data on dout.
        if (cnt == 2'd3) begin
            data  <= d;      // Load new parallel data
            cnt   <= 2'd0;   // Reset counter back to 0
            valid <= 1'b1;   // Assert valid signal on the cycle when new MSB is output
        end else begin
            // Otherwise, rotate the shift register one bit to the left.
            // The most significant bit is shifted into the least significant position,
            // maintaining the order that ensures subsequent bits of d are output.
            data  <= {data[2:0], data[3]};
            cnt   <= cnt + 1;
            valid <= 1'b0;
        end
    end
end

// Continuous assignments to drive serial output and valid signal.
// dout always presents the current MSB from the shift register.
assign dout      = data[3];
assign valid_out = valid;

endmodule