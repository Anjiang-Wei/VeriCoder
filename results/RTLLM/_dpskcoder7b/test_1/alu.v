wire [31:0] res;
    wire [31:0] slt_result;
    wire [31:0] sll_result;
    wire [31:0] srl_result;
    wire [31:0] sra_result;
    wire [31:0] sllv_result;
    wire [31:0] srlv_result;
    wire [31:0] srav_result;
    wire [31:0] lui_result;
    wire [31:0] add_result;
    wire [31:0] addu_result;
    wire [31:0] sub_result;
    wire [31:0] subu_result;
    wire [31:0] and_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;
    wire [31:0] nor_result;
    wire [31:0] slt_result;
    wire [31:0] sltu_result;

    assign add_result = a + b;
    assign addu_result = a + b;
    assign sub_result = a - b;
    assign subu_result = a - b;
    assign and_result = a & b;
    assign or_result = a | b;
    assign xor_result = a ^ b;
    assign nor_result = ~(a | b);
    assign slt_result = (signed'(a) < signed'(b)) ? 32'b1 : 32'b0;
    assign sltu_result = (a < b) ? 32'b1 : 32'b0;
    assign lui_result = {b, 16'b0};
    assign sll_result = a << b[4:0];
    assign srl_result = a >> b[4:0];
    assign sra_result = signed'({{31{a[31]}}, a} >> b[4:0]);
    assign sllv_result = a << b;
    assign srlv_result = a >> b;
    assign srav_result = signed'({{31{a[31]}}, a} >> b);

    always @(*) begin
        case(aluc)
            ADD: res = add_result;
            ADDU: res = addu_result;
            SUB: res = sub_result;
            SUBU: res = subu_result;
            AND: res = and_result;
            OR: res = or_result;
            XOR: res = xor_result;
            NOR: res = nor_result;
            SLT: res = slt_result;
            SLTU: res = sltu_result;
            LUI: res = lui_result;
            SLL: res = sll_result;
            SRL: res = srl_result;
            SRA: res = sra_result;
            SLLV: res = sllv_result;
            SRLV: res = srlv_result;
            SRAV: res = srav_result;
            default: res = 32'bz;
        endcase
    end

    assign r = res;
    assign zero = (res == 32'b0) ? 1'b1 : 1'b0;
    assign negative = res[31];
    assign carry = ^(a ^ b);
    assign overflow = (a[31] & b[31] & ~res[31]) | (~a[31] & ~b[31] & res[31]);
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;
endmodule