module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. 0 for chip reset, 1 for inactive reset signal.
    input start,        // Chip enable signal to initiate multiplication operation.
    input [15:0] ain,   // Input a (multiplicand), 16 bits wide.
    input [15:0] bin,   // Input b (multiplier), 16 bits wide.

    output [31:0] yout, // Product output, 32 bits wide.
    output done         // Completion flag, 1 indicates the operation is done.
);

    // Internal signal declarations
    reg [31:0] yout_r;      // Register to store the product.
    reg [15:0] areg;        // Register to store the multiplicand.
    reg [15:0] breg;        // Register to store the multiplier.
    reg [4:0] i;            // 5-bit register to store the shift count (0 to 16, max value 17).
    reg done_r;             // Register to store the completion flag.

    // Assign output signals
    assign yout = yout_r;
    assign done = done_r;

    // Always block for control signals and multiplication operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to their initial values
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'b0) begin
                    // Load inputs into registers at the start of the operation
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                    done_r <= 1'b0;
                    i <= i + 1;
                end else if (i > 5'b0 && i < 5'd17) begin
                    // Perform the shift-and-accumulate operation
                    if (areg[i - 1]) begin
                        yout_r <= yout_r + (breg << (i - 1));
                    end
                    i <= i + 1;
                end else if (i == 5'd16) begin
                    // Indicate completion when shift count reaches 16
                    done_r <= 1'b1;
                    i <= i + 1;
                end else if (i == 5'd17) begin
                    // Reset done_r flag after one clock cycle of completion
                    done_r <= 1'b0;
                    i <= 5'b0;  // Reset shift count register for the next operation
                end
            end else begin
                // Reset operation if `start` is inactive
                i <= 5'b0;
                done_r <= 1'b0;
            end
        end
    end

endmodule