module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

// Shift count register (i)
reg [3:0] i;

// Multiplication completion flag
reg done_r;

// Multiplicand and multiplier registers
reg [15:0] areg;
reg [15:0] breg;

// Product register
reg [31:0] yout_r;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n) // Active-low reset signal
    begin
        i <= 4'd0; // Reset shift count register to 0
        done_r <= 1'b0; // Clear multiplication completion flag
        areg <= 16'h0000; // Reset multiplicand register to 0
        breg <= 16'h0000; // Reset multiplier register to 0
        yout_r <= 32'h00000000; // Reset product register to 0
    end
    else if (start) // Start signal active
    begin
        if (i < 4'd17) // Increment shift count register until it reaches 16
            i <= i + 1;
        else // Shift count register has reached 16, indicate multiplication completion
            done_r <= 1'b1;
    end
    else // Start signal inactive
    begin
        i <= 4'd0; // Reset shift count register to 0
        done_r <= 1'b0; // Clear multiplication completion flag
    end
end

// Shift and accumulate operation
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n) // Active-low reset signal
    begin
        areg <= 16'h0000; // Reset multiplicand register to 0
        breg <= 16'h0000; // Reset multiplier register to 0
        yout_r <= 32'h00000000; // Reset product register to 0
    end
    else if (start) // Start signal active
    begin
        if (i == 4'd0) // Store multiplicand and multiplier values in registers
        begin
            areg <= ain;
            breg <= bin;
        end
        else if (i > 4'd0 && i < 4'd17) // Perform shift and accumulate operation for each bit position
        begin
            if (areg[15 - i] == 1'b1) // Check bit at current position in multiplicand register
                yout_r <= {yout_r, breg << (16 - i)}; // Accumulate shifted multiplier value
        end
    end
end

// Output assignment
assign yout = yout_r;
assign done = done_r;

endmodule