module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    // Internal registers to store the dividend and divisor
    reg [15:0] a_reg;
    reg [7:0] b_reg;

    // Internal wires for intermediate calculations
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Assign input values to registers
    always @(*) begin
        a_reg <= A;
        b_reg <= B;
    end

    // Perform the division operation
    always @(*) begin
        // Initialize quotient and remainder
        result <= 16'b0;
        odd <= 16'b0;

        // Iterate through the dividend bits
        for (integer i = 15; i >= 0; i = i - 1) begin
            // Extract the higher bits of the dividend
            wire [7:0] dividend_bits = a_reg[i:i-7];

            // Compare with the divisor
            if (dividend_bits >= b_reg) begin
                // Set the quotient bit to 1
                result[i] <= 1'b1;

                // Calculate the remainder
                remainder <= dividend_bits - b_reg;
            end else begin
                // Set the quotient bit to 0
                result[i] <= 1'b0;

                // Remainder is the same as the dividend bits
                remainder <= dividend_bits;
            end

            // Concatenate the remainder with the next dividend bit
            a_reg[i:i-7] <= {remainder, a_reg[i-8]};
        end

        // Assign the final remainder to the output
        odd <= a_reg;
    end

endmodule