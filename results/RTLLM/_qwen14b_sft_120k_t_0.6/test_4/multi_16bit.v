module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);
    reg [4:0] i;        // Shift count register.
    reg [31:0] areg;    // Register to hold multiplicand.
    reg [31:0] breg;    // Register to hold multiplier.
    reg [31:0] yout_r;  // Register to hold product output.
    reg done_r;         // Internal completion flag.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;  // Reset shift count.
        end else if (start && i < 17) begin
            i <= i + 1; // Increment shift count if not done.
        end else if (!start) begin
            i <= 5'd0;  // Reset shift count on start signal de-assertion.
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0; // Reset completion flag.
        end else if (i == 16) begin
            done_r <= 1'b1; // Set completion flag when multiplication is done.
        end else if (i == 17) begin
            done_r <= 1'b0; // Reset completion flag after finishing.
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 32'd0; // Reset multiplicand register.
            breg <= 32'd0; // Reset multiplier register.
            yout_r <= 32'd0; // Reset product register.
        end else if (start) begin
            if (i == 5'd0) begin
                areg <= {16'd0, ain}; // Load multiplicand.
                breg <= {16'd0, bin}; // Load multiplier.
            end else if (i > 0 && i < 17) begin
                if (areg[16 - i]) begin
                    yout_r <= yout_r + (breg << (i - 1)); // Accumulate product.
                end
            end
        end
    end

    assign done = done_r; // Assign internal completion flag to output.
    assign yout = yout_r; // Assign product register to output.

endmodule