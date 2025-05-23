module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

// Internal signals and registers
reg [15:0] areg;             // Register to hold multiplicand
reg [15:0] breg;             // Register to hold multiplier
reg [31:0] yout_r;           // Register to hold intermediate product result
reg [4:0] i;                 // 5-bit shift count register (0 to 17 count)
reg done_r;                  // Register for the internal done signal

// Always block to handle shift count register (i) and control signals (done)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin        // Reset condition
        i <= 0;
        done <= 0;
    end else if (start) begin
        if (i < 17) begin
            i <= i + 1;      // Increment the shift count register
        end else begin
            i <= 0;          // Reset the shift count to 0
        end
    end else begin
        i <= 0;              // Reset counter if start is inactive
        done <= 0;
    end
end

// Done flag update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 0;         // Reset done flag on active-low reset
    end else begin
        if (i == 16) begin
            done_r <= 1;     // Set done flag when multiplication is completed
        end else if (i == 17) begin
            done_r <= 0;     // Clear done flag
        end
    end
end

// Assign done flag output
assign done = done_r;

// Always block for the shift and accumulate operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin        // Reset condition
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else if (start) begin
        if (i == 0) begin
            // On shift count 0, load the multiplicand and multiplier into registers
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end else if (i > 0 && i < 17) begin
            // Shift and accumulate operation for shift counts 1 to 16
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1)); // If bit i-1 of areg is high, accumulate shifted breg
            end
        end
    end
end

// Assign the final product output
assign yout = yout_r;

endmodule