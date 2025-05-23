module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

// Data bit control signals
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
        i <= 0; // Reset shift count register to 0 on reset
    end else begin
        if (start && i < 17) begin
            i <= i + 1; // Increment shift count register on start signal and shift count less than or equal to 16
        end else begin
            i <= 0; // Reset shift count register to 0 on completion of multiplication operation
        end
    end
end

// Multiplication completion flag generation
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
        done_r <= 0; // Reset multiplication completion flag to 0 on reset
    end else begin
        if (i == 16) begin
            done_r <= 1; // Set multiplication completion flag to 1 when shift count register is equal to 16
        end else begin
            done_r <= 0; // Reset multiplication completion flag to 0 otherwise
        end
    end
end

// Shift and accumulate operation
always @*begin
    if (posedge clk) begin
        if (rst_n == 0) begin
            areg <= 0; // Reset multiplicand register to 0 on reset
            breg <= 0; // Reset multiplier register to 0 on reset
            yout_r <= 0; // Reset product register to 0 on reset
        end else begin
            if (start) begin
                areg <= ain; // Store multiplicand in multiplicand register on start signal
                breg <= bin; // Store multiplier in multiplier register on start signal
                yout_r <= 0; // Reset product register to 0 on start signal
            end else if (i < 17) begin
                if (bit[i-1, ain]) begin // Shift and accumulate operation
                    yout_r <= areg + breg * 2^i - 1; // Accumulate product of multiplier and shifted multiplicand
                end else begin
                    yout_r <= areg + breg * 2^i; // Accumulate product of multiplier and multiplicand
                end
            end else begin
                yout_r <= 0; // Reset product register to 0 on completion of multiplication operation
            end
        end
    end
endmodule