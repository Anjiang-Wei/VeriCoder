module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done          // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

    // Internal registers
    reg [15:0] areg;         // Register to store multiplicand
    reg [15:0] breg;         // Register to store multiplier
    reg [31:0] yout_r;       // Register for accumulated product
    reg [4:0] i;             // 5-bit shift count (range from 0 to 16)
    reg done_r;              // Internal done flag register

    // Main sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition - initialize all registers
            areg   <= 16'b0;
            breg   <= 16'b0;
            yout_r <= 32'b0;
            i      <= 5'b0;
            done_r <= 1'b0;
        end else if (!start) begin
            // If start signal is inactive, reset to initial state
            i      <= 5'b0;
            done_r <= 1'b0;
        end else begin
            // Start signal is active
            if (i == 0) begin
                // Capture inputs on the initial cycle (i == 0)
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'b0;  // Clear product register
                done_r <= 1'b0;
                i      <= i + 1; // Increment the shift count
            end else if (i < 17) begin
                // Perform multiplication operation
                if (areg[i-1] == 1'b1) begin
                    yout_r <= yout_r + (breg << (i-1)); // Accumulate and shift
                end
                i <= i + 1; // Increment the shift count
                if (i == 16) begin
                    // Set done flag on last active cycle of multiplication
                    done_r <= 1'b1;
                end
            end else begin
                // Reset done signal when i reaches 17
                i      <= 5'b0;
                done_r <= 1'b0;
            end
        end
    end

    // Output assignments
    assign yout = yout_r; // Assign value of product register to output
    assign done = done_r; // Assign done flag state to output

endmodule