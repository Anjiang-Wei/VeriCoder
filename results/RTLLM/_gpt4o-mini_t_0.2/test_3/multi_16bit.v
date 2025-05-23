module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal to initiate multiplication operation.
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

reg [15:0] areg;           // Register to hold multiplicand.
reg [15:0] breg;           // Register to hold multiplier.
reg [4:0] i;               // Shift count register.
reg [31:0] yout_r;         // Internal register to hold product value.
reg done_r;                // Internal register to hold done flag.

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        i <= 0;
        yout_r <= 0;
        areg <= 0;
        breg <= 0;
        done_r <= 0;
    end else begin
        // Shift count and multiplication control
        if (start) begin
            if (i < 16) begin
                i <= i + 1; // Increment shift counter
            end
        end else begin
            i <= 0; // Reset shift counter if start is inactive
        end

        // Done flag update
        if (i == 16) begin
            done_r <= 1; // Set done flag when multiplication is complete
        end else if (i == 17) begin
            done_r <= 0; // Clear done flag after it has been read
        end

        // Shift and accumulate operation
        if (i == 0) begin
            areg <= ain;    // Store multiplicand
            breg <= bin;    // Store multiplier
            yout_r <= 0;    // Reset product output
        end else if (i > 0 && i < 17) begin
            if (areg[i - 1]) begin
                yout_r <= yout_r + (breg << (i - 1)); // Accumulate shifted value if bit is set
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done <= 0;
        yout <= 0;
    end else begin
        done <= done_r; // Update done flag
        yout <= yout_r; // Update output with product
    end
end

endmodule