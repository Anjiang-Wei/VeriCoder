// Registers
    reg [15:0] a_reg;
    reg [7:0] b_reg;

    // Dividend
    always @ (A or B)
    begin
        a_reg = A;
        b_reg = B;
    end

    // Divisor
    always @ (A or B)
    begin
        if (b_reg == 0)
        begin
            result = {16{1'b0}};
            odd = {16{1'b0}};
        end
        else
        begin
            result[15] = a_reg[15] ^ b_reg[7];
            odd[15] = a_reg[15];

            for (int i = 14; i >= 0; i--)
            begin
                result[i] = a_reg[i] ^ b_reg[7];
                odd[i] = a_reg[i];
                if (result[i] == 1)
                begin
                    result[i+1:i] = 2'b01;
                    odd[i+1:i] = odd[i+1:i] << 1;
                end
            end
        end
    end
endmodule