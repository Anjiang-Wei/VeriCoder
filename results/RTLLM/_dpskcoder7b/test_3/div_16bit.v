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

    always @(A or B) begin
        a_reg = A;
        b_reg = B;
    end

    always @(a_reg or b_reg) begin
        quotient = 16'b0;
        remainder = 16'b0;
        for(int i=0; i<16; i++) begin
            if(a_reg[15:8] >= b_reg) begin
                quotient[15:8] = 1'b1;
                remainder = a_reg[15:8] - b_reg;
            end
            a_reg = {remainder[14:0], 1'b0};
        end
        result = quotient;
        odd = remainder;
    end

endmodule