// Registers
    reg [15:0] a_reg;
    reg [7:0] b_reg;

    // Wires
    wire [15:0] a_high;
    wire [15:0] a_low;
    wire [15:0] remainder;
    wire [7:0] divisor;

    // Assign inputs to registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Extract high and low bits of dividend
    assign a_high = A >> 8;
    assign a_low = A & 8'hFF;

    // Extract divisor bits
    assign divisor = b_reg;

    // Compute quotient and remainder
    always @(*) begin
        remainder = a_high - divisor;
        if (remainder < 0) begin
            result[15] = 1'b1;
            remainder = remainder + divisor;
        end else begin
            result[15] = 1'b0;
        end

        if (remainder[7] == 1'b1) begin
            odd[15] = 1'b1;
            odd[14:8] = remainder[6:0];
        end else begin
            odd[15:8] = 8'b0;
        end

        a_high = remainder;
        a_low = a_reg & 8'hFF;
    end

endmodule