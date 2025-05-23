wire signed [31:0] signed_a, signed_b;
    reg signed [31:0] res;
    assign zero = (res == 0)? 1'b1 : 1'b0;
    assign carry = (res[31]!= res[30])? 1'b1 : 1'b0;
    assign negative = (res[31]!= 0)? 1'b1 : 1'b0;
    assign overflow = (res[31]!= signed_a[31] && res[31]!= signed_b[31])? 1'b1 : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU)? 1'b1 : 1'bz;
    assign r = res;
    assign signed_a = a;
    assign signed_b = b;

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
            SLT: res = (a < b)? 1 : 0;
            SLTU: res = (a < b)? 1 : 0;
            SLL: res = {a[31:0], a[4:0]};
            SRL: res = {a[4:0], a[31:5]};
            SRA: res = {a[4:0], a[31:5]};
            SLLV: res = {a[31:0], a[4:0]};
            SRLV: res = {a[4:0], a[31:5]};
            SRAV: res = {a[4:0], a[31:5]};
            LUI: res = {a[15:0], 16'b0};
            default: res = 32'b0z;
        endcase
    end
endmodule