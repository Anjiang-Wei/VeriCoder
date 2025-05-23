module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

    reg [15:0] areg;         // Multiplicand register
    reg [15:0] breg;         // Multiplier register
    reg [4:0] i;             // Shift count register, 5 bits to count from 0 to 16
    reg [31:0] yout_r;       // Product register
    reg done_r;              // Internal completion flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end else begin
            // Shift count register logic
            if (start) begin
                if (i < 17) begin
                    i <= i + 1;
                end
            end else begin
                i <= 5'b0;
            end

            // Multiplication completion flag logic
            if (i == 16) begin
                done_r <= 1'b1; // Set done flag when multiplication is complete
            end else if (i == 17) begin
                done_r <= 1'b0; // Reset done flag after the operation is complete
            end

            // Shift and accumulate operation
            if (start) begin
                if (i == 0) begin
                    // Initial load of registers
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                end else if (i < 17) begin
                    // Shift and accumulate
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1)); // Shift left and accumulate
                    end
                end
            end
        end
    end

    // Output assignment
    assign yout = yout_r;
    assign done = done_r;

endmodule