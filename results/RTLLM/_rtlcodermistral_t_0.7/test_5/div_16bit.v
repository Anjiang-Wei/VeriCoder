module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    reg [15:0] a_reg;
    reg [7:0] b_reg;

    always @ (A, B)
    begin
        a_reg <= A;
        b_reg <= B;
    end

    always @ (A, B)
    begin
        result <= 16'h0000;
        odd <= 16'h0000;
        for (int i = 15; i >= 0; i--)
        begin
            if (a_reg[7:0] >= b_reg)
            begin
                a_reg <= a_reg - b_reg;
                result <= result << 1 | 1'b1;
                odd <= {odd[14:0], 1'b0};
            end
            else
            begin
                odd <= {odd[14:0], 1'b1};
                a_reg <= a_reg - 1;
            end
        end
    end

endmodule