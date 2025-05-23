module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.
    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

    reg [15:0] areg;          // Register for storing multiplicand.
    reg [15:0] breg;          // Register for storing multiplier.
    reg [31:0] yout_r;        // Internal product register.
    reg [4:0] i;              // 5-bit counter for shift operations (0 to 16).
    reg done_r;               // Internal done flag.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition: Initialize all registers and flags.
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    // Load the multiplicand and multiplier into registers on start.
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;  // Clear the product register.
                    done_r <= 1'b0;   // Clear the done signal.
                    i <= i + 1;       // Increment the shift counter.
                end else if (i > 0 && i <= 16) begin
                    // Perform shift and accumulate operation.
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i - 1));
                    end
                    i <= i + 1;       // Increment the shift counter.
                end else if (i == 17) begin
                    // Complete operation.
                    done_r <= 1'b1;   // Set the done flag.
                    i <= 0;           // Reset the counter for the next operation.
                end
            end else begin
                // If start is deasserted, clear internal variables and flags.
                i <= 0;
                done_r <= 1'b0;
            end
        end
    end

    // Output assignments.
    assign yout = yout_r;  // Assign the internal product register to the output.
    assign done = done_r;  // Assign the internal done flag to the output.

endmodule