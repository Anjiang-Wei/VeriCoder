module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;    // Internal register to hold the input data
    reg [1:0] cnt;     // 2-bit counter to keep track of the bit position

    always @(posedge clk or negedge rst_n) begin
        // Asynchronous reset (active low)
        if (!rst_n) begin
            data <= 4'b0;         // Reset data register to zero
            cnt <= 2'b0;         // Reset counter to zero
            valid_out <= 1'b0;   // Reset valid_out signal to zero
            dout <= 1'b0;        // Reset dout signal to zero
        end else begin
            if (cnt == 2'b11) begin
                // If counter is 3 (last bit), prepare for the next 4 bits
                data <= d;        // Load new parallel input data into internal register
                cnt <= 2'b00;     // Reset counter to zero
                dout <= d[3];     // Output the MSB (most significant bit)
                valid_out <= 1'b1; // Indicate valid data is available
            end else begin
                // During intermediate cycles, output the next bits
                cnt <= cnt + 1'b1;       // Increment the counter
                dout <= data[3];         // Output current MSB
                data <= {data[2:0], 1'b0}; // Shift data left, filling LSB with 0
                valid_out <= 1'b0;       // Indicate invalid data during intermediate cycles
            end
        end
    end

endmodule