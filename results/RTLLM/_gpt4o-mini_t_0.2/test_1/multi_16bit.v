module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done         // Chip output flag signal. Indicates multiplication operation completion.
);

    reg [15:0] areg; // Multiplicand register
    reg [15:0] breg; // Multiplier register
    reg [5:0] i;     // Shift count register
    reg [31:0] yout_r; // Product register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            i <= 0;
            done <= 0;
        end else begin
            if (start) begin
                if (i < 16) begin
                    if (i == 0) begin
                        // On first cycle, load inputs
                        areg <= ain;
                        breg <= bin;
                        yout_r <= 0;  // Reset product register
                    end else begin
                        // Shift and accumulate operation
                        if (areg[i-1]) begin
                            yout_r <= yout_r + (breg << (i - 1)); // Accumulate
                        end
                    end
                    i <= i + 1; // Increment shift count
                end else if (i == 16) begin
                    done <= 1; // Indicate multiplication done
                    i <= 17; // Move to state indicating operation complete
                end
            end else begin
                // Reset shift count if start is inactive
                i <= 0;
                done <= 0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 0; // Reset product output
        end else if (i == 17) begin
            yout <= yout_r; // Output the final product
            done <= 0; // Reset done flag for next operation
        end
    end
endmodule