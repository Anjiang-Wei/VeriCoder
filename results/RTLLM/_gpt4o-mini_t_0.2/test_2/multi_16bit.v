module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

    reg [15:0] areg;        // Register to store multiplicand
    reg [15:0] breg;        // Register to store multiplier
    reg [31:0] yout_r;      // Register for the product output
    reg [4:0] shift_count;  // Shift count register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            shift_count <= 0;
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            done <= 0;
        end else begin
            if (start) begin
                if (shift_count < 16) begin // Start the multiplication operation
                    if (shift_count == 0) begin
                        // On first iteration, initialize registers
                        areg <= ain;
                        breg <= bin;
                        yout_r <= 0;
                    end else begin
                        if (areg[shift_count - 1]) begin
                            // Accumulate the shifted multiplier into product
                            yout_r <= yout_r + (breg << (shift_count - 1));
                        end
                    end
                    shift_count <= shift_count + 1; // Increment the shift count
                end else if (shift_count == 16) begin
                    // Set the done flag when multiplication is complete
                    done <= 1;
                end else if (shift_count == 17) begin
                    // Reset done flag for the next operation
                    done <= 0;
                    shift_count <= 0; // Reset shift count for next operation
                    yout <= yout_r;   // Assign the product output
                end
            end else begin
                // Reset shift count if start signal is inactive
                shift_count <= 0;
            end
        end
    end

    // Continuous assignment of product output
    always @(posedge clk) begin
        yout <= yout_r; // Assign product output on clock edge
    end

endmodule