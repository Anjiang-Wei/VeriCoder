module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done         // Chip output flag signal. Defined as 1 for multiplication completion.
);

reg [15:0] areg;          // Multiplicand register
reg [15:0] breg;          // Multiplier register
reg [5:0] i;              // Shift count register
reg [31:0] yout_r;        // Product register
reg done_r;               // Intermediate completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset state
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        i <= 0;
        done_r <= 0;
    end else begin
        if (start) begin
            if (i < 16) begin
                i <= i + 1;
            end
        end else begin
            i <= 0;
        end
    
        // Multiplication operation
        if (i == 0) begin
            areg <= ain;  // Store multiplicand
            breg <= bin;  // Store multiplier
            yout_r <= 0;  // Reset product register
        end else if (i > 0 && i < 17) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1)); // Accumulate
            end
        end

        // Completion flag logic
        if (i == 16) begin
            done_r <= 1; // Set done flag if multiplication is complete
        end else if (i == 17) begin
            done_r <= 0; // Reset done flag after completion
        end
    end
end

// Assign outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout <= 0;
        done <= 0;
    end else begin
        yout <= yout_r;  // Output the product
        done <= done_r;  // Output the completion flag
    end
end

endmodule