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
    reg valid;       // Valid signal to indicate availability of serial output

    // Output signal assignment
    assign valid_out = valid;
    assign dout = data[3];  // Output the most significant bit of data

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 4'b0;  // Reset data to 0
            cnt <= 2'b0;   // Reset counter to 0
            valid <= 1'b0; // Reset valid signal to 0
        end else begin
            if (cnt == 2'b11) begin  // Counter reaches 3 (binary 11)
                data <= d;           // Load new parallel data
                cnt <= 2'b0;         // Reset counter
                valid <= 1'b1;       // Set valid signal to 1
            end else begin
                cnt <= cnt + 1;      // Increment counter
                valid <= 1'b0;       // Set valid signal to 0
                data <= {data[2:0], 1'b0};  // Shift data register left
            end
        end
    end

    // Combinational logic to shift data register left
    always @(posedge clk) begin
        if (cnt != 2'b11) begin
            data <= {data[2:0], 1'b0};  // Shift data register left
        end
    end
endmodule