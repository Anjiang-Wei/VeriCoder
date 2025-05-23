module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );

    reg [15:0] a_reg;
    reg [7:0] b_reg;

    // Combinational block to store inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational block to perform division
    always @(*) begin
        if (b_reg == 0) begin
            result = 16'h0000;
            odd = a_reg;
        end else begin
            reg [15:0] remainder;
            reg [15:0] quotient;
            remainder = a_reg;
            quotient = 16'h0000;
            for (int i = 7; i >= 0; i = i - 1) begin
                if (remainder[15:8] >= b_reg) begin
                    remainder = {remainder[7:0], remainder[15:8] - b_reg};
                    quotient = {quotient[14:0], 1'b1};
                end else begin
                    remainder = {remainder[7:0], remainder[15:8]};
                    quotient = {quotient[14:0], 1'b0};
                end
            end
            result = quotient;
            odd = remainder;
        end
    end

endmodule