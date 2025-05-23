module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);
    reg [4:0] i;      // Shift count register
    reg [15:0] areg;  // Multiplicand register
    reg [15:0] breg;  // Multiplier register
    reg [31:0] yout_r; // Product register
    reg done_r;       // Multiplication completion flag register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;       // Reset shift count
            areg <= 16'd0;   // Reset multiplicand
            breg <= 16'd0;   // Reset multiplier
            yout_r <= 32'd0; // Reset product
            done_r <= 1'b0;  // Reset done flag
        end else begin
            if (start) begin
                if (i < 17) begin
                    if (i == 0) begin
                        areg <= ain;  // Load multiplicand
                        breg <= bin;  // Load multiplier
                    end else if (i == 16) begin
                        done_r <= 1'b1;  // Set done flag
                    end else if (i == 17) begin
                        done_r <= 1'b0;  // Reset done flag
                    end else if (areg[i-1] == 1'b1) begin
                        yout_r <= yout_r + (breg << (i-1)); // Accumulate product
                    end
                    i <= i + 1'b1; // Increment shift count
                end
            end else begin
                i <= 5'd0;       // Reset shift count
                areg <= 16'd0;   // Reset multiplicand
                breg <= 16'd0;   // Reset multiplier
                yout_r <= 32'd0; // Reset product
            end
        end
    end

    assign done = done_r;  // Assign done flag
    assign yout = yout_r;  // Assign product output
endmodule