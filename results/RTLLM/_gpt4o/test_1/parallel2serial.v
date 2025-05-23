module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

    // Internal registers
    reg [3:0] data;   // Register to hold the current 4-bit data being serialized
    reg [2:0] cnt;    // 3-bit counter, since we need to count up to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous Reset: Reset all states
            cnt <= 3'd0;
            data <= 4'd0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 3'd3) begin
                // On the fourth clock cycle, load new parallel data and reset the counter
                data <= d;         // Load new parallel data into the shift register
                cnt <= 3'd0;       // Reset counter
                dout <= d[3];      // Output MSB of the new data as first serial bit
                valid_out <= 1'b1; // Indicate that valid data is being output
            end else begin
                // Normal operation: Shift data and increment the counter
                cnt <= cnt + 1;    // Increment counter
                dout <= data[3];   // Output MSB of the current data
                data <= {data[2:0], 1'b0}; // Shift the register left (serialization)
                valid_out <= 1'b0; // Reset valid signal during intermediate cycles
            end
        end
    end

endmodule