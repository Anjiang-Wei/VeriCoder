module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    reg [15:0] a_reg, b_reg;
    wire [15:0] a, b;
    wire [15:0] quotient, remainder;
    wire [7:0] divisor;

    // Assign the input values to registers for stability
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform the division operation
    always @(*) begin
        if (b_reg == 0) begin
            quotient = 16'b0; // Avoid division by zero
            remainder = a_reg;
        end else begin
            divisor = b_reg;
            quotient = 16'b0;
            remainder = a_reg;

            for (integer i = 0; i < 8; i = i + 1) begin
                if (remainder[15:8] >= divisor) begin
                    quotient[15 - i] = 1'b1;
                    remainder[15:8] = remainder[15:8] - divisor;
                end
                remainder = {remainder[14:0], 1'b0};
            end

            for (integer i = 0; i < 8; i = i + 1) begin
                if (remainder[7:0] >= divisor) begin
                    quotient[7 - i] = 1'b1;
                    remainder[7:0] = remainder[7:0] - divisor;
                end
                remainder = {remainder[6:0], 1'b0};
            end
        end
    end

    // Assign the results to the output ports
    assign result = quotient;
    assign odd = remainder;

endmodule