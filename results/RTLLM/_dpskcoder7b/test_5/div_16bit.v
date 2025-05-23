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
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg [15:0] remainder_reg;

    always @(A or B) begin
        a_reg <= A;
        b_reg <= B;
    end

    always @(a_reg or b_reg) begin
        dividend = a_reg;
        divisor = {16{b_reg}};
        quotient = 16'b0;
        remainder = 16'b0;
        remainder_reg = 16'b0;

        for (integer i = 0; i < 16; i = i + 1) begin
            if (dividend[15:0] > divisor) begin
                quotient[i] = 1'b1;
                remainder = dividend - divisor;
            end else begin
                quotient[i] = 1'b0;
                remainder = dividend;
            end
            dividend = {remainder[14:0], 1'b0};
            remainder_reg = remainder;
        end

        result = quotient;
        odd = remainder_reg;
    end

endmodule