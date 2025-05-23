module div_16bit(
    input wire [15:0] A,     // 16-bit dividend
    input wire [7:0] B,      // 8-bit divisor
    output wire [15:0] result,   // 16-bit quotient
    output wire [15:0] odd       // 16-bit remainder
    );

    // Internal registers
    reg [15:0] quotient;     // To hold the final quotient
    reg [15:0] remainder;    // To hold the remainder during computation
    reg [23:0] dividend_ext; // Extended dividend (include higher bits for subtraction)
    reg [7:0] divisor;       // Internal divisor (8 bits)

    integer i; // Loop variable

    // Always block to compute division
    always @(*) begin
        // Initialize internal values
        quotient = 16'd0;              // Reset quotient
        remainder = 16'd0;             // Reset remainder
        dividend_ext = {8'd0, A};      // Extended dividend, upper 8 bits set to 0
        divisor = B;                   // Divisor directly taken from input

        // Perform the division process bit by bit
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in the next bit of dividend
            remainder = {remainder[14:0], dividend_ext[15]};
            dividend_ext = {dividend_ext[22:0], 1'b0}; // Remove the processed bit

            // Compare remainder with divisor
            if (remainder >= divisor) begin
                remainder = remainder - divisor;  // Subtract divisor from remainder
                quotient[i] = 1;                 // Set corresponding quotient bit
            end else begin
                quotient[i] = 0;                 // Otherwise, set quotient bit to 0
            end
        end
    end

    // Assign outputs
    assign result = quotient; // Final 16-bit quotient
    assign odd = remainder;   // Final 16-bit remainder
endmodule