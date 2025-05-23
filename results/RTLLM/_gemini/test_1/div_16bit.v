module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    // Internal registers to store the dividend and divisor
    reg [15:0] a_reg;
    reg [7:0] b_reg;

    // Internal registers to store the quotient and remainder
    reg [15:0] quotient;
    reg [15:0] remainder;

    // Assign input values to registers
    always @(*) begin
        a_reg <= A;
        b_reg <= B;
    end

    // Perform the division operation
    always @(*) begin
        // Initialize quotient and remainder
        quotient <= 16'b0;
        remainder <= 16'b0;

        // Iterate through the dividend bits
        for (integer i = 15; i >= 0; i = i - 1) begin
            // Extract the higher bits of the dividend
            remainder[15:8] <= a_reg[i:i-7];

            // Compare with the divisor
            if (remainder[15:8] >= b_reg) begin
                // Set quotient bit to 1
                quotient[i] <= 1'b1;

                // Calculate the remainder
                remainder[15:8] <= remainder[15:8] - b_reg;
            end else begin
                // Set quotient bit to 0
                quotient[i] <= 1'b0;
            end

            // Concatenate the remainder with the next dividend bit
            remainder[7:0] <= {remainder[8:1], a_reg[i-8]};
        end
    end

    // Assign output values
    assign result = quotient;
    assign odd = remainder;

endmodule