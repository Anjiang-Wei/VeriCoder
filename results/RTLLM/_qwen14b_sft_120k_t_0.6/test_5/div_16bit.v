module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);
    reg [15:0] a_reg, b_reg;
    reg [15:0] quotient, remainder;
    reg [7:0] dividend_part;
    integer i;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        quotient = 16'b0;
        remainder = 16'b0;

        // Perform division for each 8-bit part of the dividend
        for (i = 0; i < 2; i = i + 1) begin
            dividend_part = a_reg[15:8]; // Extract the highest 8 bits of the dividend
            if (dividend_part >= b_reg) begin
                quotient = quotient + 1;
                remainder = remainder + (dividend_part - b_reg);
            end else begin
                remainder = remainder + dividend_part;
            end
            a_reg = {a_reg[7:0], 8'b0}; // Shift the dividend left by 8 bits
        end

        // Store the final quotient and remainder
        result = quotient;
        odd = remainder;
    end

endmodule