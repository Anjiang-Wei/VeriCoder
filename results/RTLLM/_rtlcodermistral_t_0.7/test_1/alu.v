```verilog
    wire signed [31:0] a_signed = $signed(a);
    wire signed [31:0] b_signed = $signed(b);
    wire signed [31:0] res_signed;
    reg signed [31:0] res;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;
    wire flag;

    assign zero = (res_signed == 0);
    assign carry = (res[31] == 1);
    assign negative = (res_signed < 0);
    assign overflow = ((a_signed > 32'h7FFFFFFF) && (b_signed > 32'h7FFFFFFF) && (res_signed < 32'h80000000)) || ((a_signed < 32'h80000000) && (b_signed < 32'h80000000) && (res_signed > 32'h7FFFFFFF));

    always @(*) begin
        case(aluc)
            ADD: res = a + b;
            ADDU: res = a + b;
            SUB: res = a - b;
            SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: flag = 1; res = a_signed < b_signed ? 1 : 0;
            SLTU: flag = 1; res = a < b ? 1 : 0;
            SLL: res = a << b[4:0];
            SRL: res = a >> b[4:0];
            SRA: res = $signed($signed(a) >>> b[4:0]);
            SLLV: res = a << b;
            SRLV: res = a >> b;
            SRAV: res = $signed($signed(a) >>> b);
            LUI: res = {16'b0, a[31:16]};
            default: res = 32'bz;
        endcase
    end

endmodule