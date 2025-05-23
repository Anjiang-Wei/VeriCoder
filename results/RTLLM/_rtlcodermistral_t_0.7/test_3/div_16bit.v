module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    reg [7:0] b_reg;
    reg [15:0] a_reg;
    reg [15:0] remainder;
    reg [15:0] quotient;
    reg [15:0] odd_reg;
    reg [15:0] temp;
    integer i;

    always @(*) begin
        a_reg = A;
        b_reg = B;
        remainder = {16'b0, a_reg[7:0]};
        quotient = {16'b0, 8'b0};
        odd_reg = {16'b0, a_reg[7:0]};
    end

    always @(*) begin
        for (i = 15; i >= 0; i--) begin
            if (remainder[15:i] >= b_reg) begin
                quotient[i] = 1'b1;
                remainder[15:i] = remainder[15:i] - b_reg;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        
        for (i = 15; i >= 0; i--) begin
            if (quotient[i] == 1'b1) begin
                odd_reg[i+1:0] = remainder[15:i];
                odd_reg[i] = 1'b1;
                break;
            end
        end
    end

    assign result = quotient;
    assign odd = odd_reg;

endmodule