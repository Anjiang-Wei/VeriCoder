module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    reg [15:0] a_reg, b_reg;
    reg [15:0] quotient, remainder;

    // First always block: register inputs
    always @* begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: perform division
    always @* begin
        quotient = 16'b0;
        remainder = 16'b0;

        for (int i = 0; i < 8; i = i + 1) begin
            // Shift remainder left by 1 bit
            remainder = {remainder[14:0], 1'b0};
            // Extract 8 bits from a_reg starting from i*8
            wire [7:0] dividend_part = a_reg[i*8 +: 8];
            // Compare dividend part with divisor
            if (dividend_part >= b_reg) begin
                // Set quotient bit
                quotient[i] = 1'b1;
                // Set remainder
                remainder = remainder - b_reg;
            end
        end

        // Assign outputs
        result = quotient;
        odd = remainder;
    end

endmodule