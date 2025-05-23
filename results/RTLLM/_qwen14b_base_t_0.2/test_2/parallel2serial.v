module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);
    // Internal signals and registers
    reg [3:0] data; // 4-bit register to hold the parallel data
    reg [1:0] cnt;  // 2-bit counter to count the number of bits output
    reg valid;      // Valid signal to indicate the availability of serial output

    // Output signal assignment
    assign dout = data[0]; // The least significant bit of data is the serial output
    assign valid_out = valid; // Valid signal is assigned to valid_out

    // Always block for clocked logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset conditions
            data <= 4'b0; // Clear data register
            cnt <= 2'b0;  // Reset counter
            valid <= 1'b0; // Clear valid signal
        end else begin
            // Normal operation
            if (cnt == 2'b11) begin // When counter reaches 3 (binary 11)
                data <= d; // Load new parallel data into data register
                cnt <= 2'b0; // Reset counter
                valid <= 1'b1; // Set valid signal to indicate new data is available
            end else begin
                cnt <= cnt + 1; // Increment counter
                valid <= 1'b0; // Clear valid signal for this cycle
                data <= {data[2:0], 1'b0}; // Shift data register left, filling with 0
            end
        end
    end

    // Always block for combinational logic to shift data
    always @(*) begin
        if (cnt == 2'b11) begin
            data[0] <= d[3]; // On the last cycle, load MSB of d into data[0]
        end else begin
            data[0] <= data[3]; // Shift data left, MSB to LSB
        end
    end
endmodule