module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter to track the bit output (0 to 3)
    reg [3:0] data;     // Register to hold parallel input data for shifting

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;       // Reset counter
            valid_out <= 0; // Reset valid_out signal
            dout <= 0;      // Reset dout signal
            data <= 0;      // Reset data register
        end else begin
            if (cnt == 0) begin
                data <= d;         // On the first cycle, load the data
                valid_out <= 1;    // Indicate valid output
                dout <= data[3];   // Output MSB
            end else if (cnt < 4) begin
                valid_out <= 1;     // Continue to indicate valid output
                dout <= data[3-cnt]; // Output the respective bit
            end

            cnt <= (cnt == 3) ? 0 : cnt + 1; // Increment or reset counter to 0 after 3
        end
    end

endmodule