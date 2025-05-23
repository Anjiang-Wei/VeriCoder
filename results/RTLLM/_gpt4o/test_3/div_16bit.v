module div_16bit(
    input wire [15:0] A,     // 16-bit dividend
    input wire [7:0] B,      // 8-bit divisor
    output wire [15:0] result, // 16-bit quotient
    output wire [15:0] odd     // 16-bit remainder
);

    // Internal registers
    reg [15:0] quotient;     // To store the quotient
    reg [15:0] remainder;    // To store the remainder
    reg [15:0] a_reg;        // Copy of the dividend (A)
    reg [7:0] b_reg;         // Copy of the divisor (B)
    integer i;               // Loop variable

    // Combinational logic for division
    always @(*) begin
        // Initialize variables
        a_reg = A;           // Initialize a_reg with the dividend
        b_reg = B;           // Initialize b_reg with the divisor
        quotient = 16'd0;    // Start quotient at 0
        remainder = 16'd0;   // Start remainder at 0

        // Perform the division algorithm
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift the remainder left by 1 and bring down the next bit of a_reg
            remainder = {remainder[14:0], a_reg[15]};
            a_reg = a_reg << 1;

            // Compare the remainder with the divisor (b_reg)
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg; // Subtract divisor from remainder
                quotient = {quotient[14:0], 1'b1}; // Set the quotient bit to 1
            end else begin
                quotient = {quotient[14:0], 1'b0}; // Set the quotient bit to 0
            end
        end
    end

    // Assign outputs
    assign result = quotient;  // Quotient is the output result
    assign odd = remainder;    // Remainder is the output odd

endmodule