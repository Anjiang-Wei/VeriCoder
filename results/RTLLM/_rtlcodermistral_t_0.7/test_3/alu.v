```verilog
    wire signed [31:0] a_s;
    wire signed [31:0] b_s;
    wire signed [31:0] res_s;
    assign a_s = $signed(a);
    assign b_s = $signed(b);
    assign res_s = $signed(r);
    assign zero = (res_s == 0);
    assign carry = (aluc == ADD && (a_s[31] & b_s[31] & ~res_s[31])) ||
                   (aluc == SUB && (a_s[31] ^ b_s[31] & res_s[31])) ||
                   (aluc == SLLV && (a_s[4:0] != 0)) ||
                   (aluc == SRLV && (a_s[4:0] != 0)) ||
                   (aluc == SRAV && (a_s[4:0] != 0));
    assign negative = (res_s[31] == 1);
    assign overflow = ((aluc == ADD && (a_s[31] ^ b_s[31] ^ res_s[31])) ||
                       (aluc == SUB && (a_s[31] ^ b_s[31] ^ ~res_s[31])) ||
                       (aluc == SLLV && (a_s[4:0] != 0)) ||
                       (aluc == SRLV && (a_s[4:0] != 0)) ||
                       (aluc == SRAV && (a_s[4:0] != 0)));
    assign flag = (aluc == SLT || aluc == SLTU) ? 1 : 'z;
    always @(*) begin
        case (aluc)
            ADD: r = a + b;
            ADDU: r = a + b;
            SUB: r = a - b;
            SUBU: r = a - b;
            AND: r = a & b;
            OR: r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: r = ((a < b) && (aluc == SLT)) ? 1 : 0;
            SLTU: r = ((a < b) && (aluc == SLTU)) ? 1 : 0;
            SLL: r = a << a[4:0];
            SRL: r = a >> a[4:0];
            SRA: r = $signed($signed(a) >> a[4:0]);
            SLLV: r = a << b;
            SRLV: r = a >> b;
            SRAV: r = $signed($signed(a) >> b);
            LUI: r = {16'b0, a[31:16]};
            default: r = 32'bz;
        endcase
    end
endmodule