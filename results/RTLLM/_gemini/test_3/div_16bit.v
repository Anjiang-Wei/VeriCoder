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

    // Assign input values to registers
    always @(*) begin
        a_reg <= A;
        b_reg <= B;
    end

    // Perform division operation
    always @(*) begin
        quotient = 16'b0;
        remainder = 16'b0;
        for (integer i = 15; i >= 0; i = i - 1) begin
            if (i >= 8) begin
                if (a_reg[i:i-7] >= b_reg) begin
                    quotient[i] = 1'b1;
                    remainder[i:i-7] = a_reg[i:i-7] - b_reg;
                end else begin
                    quotient[i] = 1'b0;
                    remainder[i:i-7] = a_reg[i:i-7];
                end
            end else begin
                if (remainder[i+8:i+1] >= b_reg) begin
                    quotient[i] = 1'b1;
                    remainder[i:i-7] = remainder[i+8:i+1] - b_reg;
                end else begin
                    quotient[i] = 1'b0;
                    remainder[i:i-7] = remainder[i+8:i+1];
                end
            end
        end
    end

    // Assign outputs
    assign result = quotient;
    assign odd = remainder;

endmodule