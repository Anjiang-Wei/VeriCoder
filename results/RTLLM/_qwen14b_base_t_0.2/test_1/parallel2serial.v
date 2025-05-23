module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);
    // Internal signals and registers
    reg [3:0] data;  // Register to hold the parallel data
    reg [1:0] cnt;   // Counter to track the number of bits output
    reg valid;       // Valid signal indicating the availability of serial output

    // Output signal assignment
    assign dout = data[0];  // The least significant bit of data is the serial output

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 4'b0;  // Reset data register to 0
            cnt <= 2'b0;   // Reset counter to 0
            valid <= 0;    // Reset valid signal to 0
        end else begin
            if (cnt == 2'b11) begin  // When cnt is 3 (binary 11)
                data <= d;           // Load new parallel data
                cnt <= 2'b0;         // Reset counter
                valid <= 1;          // Set valid signal to 1
            end else begin
                cnt <= cnt + 1;      // Increment counter
                valid <= 0;          // Set valid signal to 0
                data <= {data[2:0], 1'b0};  // Shift data register left, filling with 0
            end
        end
    end

    // Assign valid_out to the valid signal
    assign valid_out = valid;
endmodule