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

    // Assign the input values to the registers
    always @(*) begin
        a_reg <= A;
        b_reg <= B;
    end

    // Perform the division operation
    always @(*) begin
        quotient = 16'b0;
        remainder = 16'b0;
        for (integer i = 15; i >= 0; i = i - 1) begin
            // Extract the higher bits of the dividend
            remainder = {remainder[15:1], a_reg[i]};

            // Compare the dividend bits with the divisor
            if (remainder[15:8] >= b_reg) begin
                quotient[i] = 1'b1;
                remainder = remainder - {8'b0, b_reg};
            end else begin
                quotient[i] = 1'b0;
            end
        end
    end

    // Assign the output values
    assign result = quotient;
    assign odd = remainder;

endmodule