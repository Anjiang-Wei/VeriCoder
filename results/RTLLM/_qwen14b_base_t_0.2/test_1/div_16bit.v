module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);
    wire [15:0] dividend = A;
    wire [7:0] divisor = B;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Initialize quotient and remainder
    assign result = quotient;
    assign odd = remainder;

    // Combinational logic for division
    always @(*) begin
        // Initialize quotient and remainder
        quotient = 16'b0;
        remainder = 16'b0;

        // Process each bit of the dividend
        for (int i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1
            remainder = {remainder[14:0], 1'b0};
            // Add current bit of dividend to remainder
            remainder = remainder + dividend[i];

            // If remainder is greater than or equal to divisor
            if (remainder >= divisor) begin
                // Subtract divisor from remainder
                remainder = remainder - divisor;
                // Set quotient bit to 1
                quotient[i] = 1'b1;
            end else begin
                // Set quotient bit to 0
                quotient[i] = 1'b0;
            end
        end
    end
endmodule