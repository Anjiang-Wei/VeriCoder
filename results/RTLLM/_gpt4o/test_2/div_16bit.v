module div_16bit(
    input wire [15:0] A,             // 16-bit dividend
    input wire [7:0] B,              // 8-bit divisor
    output reg [15:0] result,        // 16-bit quotient
    output reg [15:0] odd            // 16-bit remainder
);

    integer i;                       // Counter for bit processing
    reg [15:0] remainder;            // Holds the intermediate remainder
    reg [7:0] temp_dividend_bits;    // Holds the higher (8-bit) portion of the dividend

    always @(*) begin
        // Initialize the quotient, remainder, and temporary variables
        result = 16'b0;
        remainder = 16'b0;

        // Process each bit of the dividend, starting from the Most Significant Bit (MSB)
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down the next bit of the dividend
            remainder = {remainder[14:0], A[i]};

            // Extract the high 8 bits of the remainder for comparison with the divisor
            temp_dividend_bits = remainder[15:8];

            // Compare the high 8 bits of the remainder with the divisor
            if (temp_dividend_bits >= B) begin
                // If greater, subtract divisor and set the quotient bit to 1
                remainder[15:8] = temp_dividend_bits - B;
                result[i] = 1;
            end else begin
                // Otherwise, the quotient bit remains 0
                result[i] = 0;
            end
        end

        // After the loop, the remainder contains the final remainder
        odd = remainder;
    end

endmodule