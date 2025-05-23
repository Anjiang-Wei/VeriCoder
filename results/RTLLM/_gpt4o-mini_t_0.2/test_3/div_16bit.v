module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
    reg [15:0] a_reg;  // Register to hold the dividend
    reg [7:0] b_reg;   // Register to hold the divisor
    reg [15:0] remainder; // Holds the current remainder

    always @(*) begin
        a_reg = A;   // Update the dividend register
        b_reg = B;   // Update the divisor register
        result = 0;  // Initialize quotient
        remainder = 0; // Initialize remainder

        // Iterate through each bit of the dividend
        for (integer i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[14:0], a_reg[i]}; // Concatenate the next bit of dividend

            if (remainder >= {8'b0, b_reg}) begin // Compare: extend b_reg to match remaining bits
                remainder = remainder - {8'b0, b_reg}; // Update remainder
                result[i] = 1'b1; // Set quotient bit if division is possible
            end else begin
                result[i] = 1'b0; // Otherwise, set quotient bit to 0
            end
        end

        odd = remainder; // Final remainder after all bits processed
    end
endmodule