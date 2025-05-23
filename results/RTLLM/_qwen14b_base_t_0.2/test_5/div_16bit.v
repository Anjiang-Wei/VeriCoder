module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);
    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] quotient;
    reg [15:0] remainder;

    // Combinational block to perform a single step of division
    always @(*) begin
        // Initialize registers with input values
        a_reg = A;
        b_reg = B;

        // Extract the highest 8 bits of the dividend
        wire [7:0] dividend_high = a_reg[15:8];

        // Compare the highest 8 bits of the dividend with the divisor
        if (dividend_high >= b_reg) begin
            // If the dividend bits are greater, set the quotient bit to 1
            quotient = 16'b1;
            // Calculate the remainder
            remainder = dividend_high - b_reg;
        end else begin
            // If the dividend bits are less, set the quotient bit to 0
            quotient = 16'b0;
            // No change in remainder
            remainder = dividend_high;
        end

        // Concatenate the remainder with the next highest bit of the dividend
        remainder = {remainder[7:0], a_reg[7]};
        // Shift the quotient left by 1
        quotient = {quotient[14:0], 1'b0};

        // Assign the outputs
        result = quotient;
        odd = remainder;
    end
endmodule