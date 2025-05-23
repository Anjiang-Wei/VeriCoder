```verilog
    reg [31:0] res;
    wire signed [31:0] a_signed, b_signed;
    assign a_signed = $signed(a);
    assign b_signed = $signed(b);
    assign zero = (res == 0);
    assign carry = res[31];
    assign negative = res[31];
    assign overflow = ((a_signed[31] == b_signed[31]) && (res[31] != a_signed[31]));
    assign flag = (aluc == SLT) || (aluc == SLTU) ? 1 : 1'z;
    always @*
    begin
        case (aluc)
            ADD: res = a_signed + b_signed;
            ADDU: res = a + b;
            SUB: res = a_signed - b_signed;
            SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = (a_signed < b_signed) ? 1 : 0;
            SLTU: res = ((a < b) ? 1 : 0) & ((a[31] == 0) ? 1 : 0);
            SLL: res = a << b;
            SRL: res = a >> b;
            SRA: res = $signed({a[31], a[30:0]}) >> b;
            SLLV: res = a << b;
            SRLV: res = a >> b;
            SRAV: res = $signed({a[31], a[30:0]}) >> b;
            LUI: res = {16'b0, a[31:16]};
            default: res = 1'z;
        endcase
    end
    assign r = res;
endmodule