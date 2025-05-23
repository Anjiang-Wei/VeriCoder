module div_16bit(
    input wire [15:0] A,       // 16-bit dividend
    input wire [7:0]  B,       // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd      // 16-bit remainder
    );

    // Internal registers for intermediate calculations
    reg [15:0] dividend;       // Modified dividend in each iteration
    reg [7:0]  divisor;        // Copy of 8-bit divisor for calculations
    reg [7:0]  temp;           // Temporary register to hold comparison values
    integer i;                 // Iterator for the loop

    always @(*) begin
        // Initialize the registers
        dividend = A;          // Store the 16-bit dividend
        divisor = B;           // Store the 8-bit divisor
        result = 16'b0;        // Initialize quotient to 0
        odd = 16'b0;           // Initialize remainder to 0

        // Edge case: Check if divisor is zero
        if (divisor == 0) begin
            result = 16'b0;    // Quotient is zero
            odd = 16'b0;       // Remainder is undefined, set to zero
        end else begin
            // Perform the division process bit-by-bit
            // Start from the MSB of the dividend and process down to the LSB
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift the higher bits of the remainder left and copy the i-th bit of dividend
                odd = {odd[14:0], dividend[15 - i]};

                // Compare the shifted remainder (odd) with the divisor
                if (odd >= divisor) begin
                    // If odd >= divisor, set the corresponding quotient bit to 1
                    odd = odd - divisor; // Update the remainder
                    result[i] = 1'b1;    // Set the quotient bit
                end else begin
                    // Otherwise, leave the quotient bit as 0
                    result[i] = 1'b0;
                end
            end
        end
    end

endmodule