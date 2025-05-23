module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.
    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal.
);

    // Internal registers
    reg [15:0] areg;            // Register for storing multiplicand
    reg [15:0] breg;            // Register for storing multiplier
    reg [31:0] yout_r;          // Register for storing the product
    reg [4:0] i;                // Shift count register (5 bits to count up to 17)
    reg done_r;                 // Register for the done signal

    // Output assignments
    assign yout = yout_r;       // Assign internal product register to the output
    assign done = done_r;       // Assign internal done register to the output

    // Always block for shift count, done, and multiplication operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition: Reset all registers to initial states
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end else if (start) begin
            if (i == 5'b0) begin
                // Start of operation: Capture inputs into registers
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                done_r <= 1'b0;
                i <= i + 1;
            end else if (i < 5'd17) begin
                // Perform shift and accumulate operation
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
            end else if (i == 5'd16) begin
                // Indicate multiplication completion
                done_r <= 1'b1;
                i <= i + 1; // Move to 17 to allow resetting done_r
            end else if (i == 5'd17) begin
                // Reset done signal
                done_r <= 1'b0;
                i <= 5'b0;
            end
        end else begin
            // When start is inactive, reset shift counter and done flag
            i <= 5'b0;
            done_r <= 1'b0;
        end
    end

endmodule