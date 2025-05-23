```verilog
    reg [31:0] res;
    reg zero;
    reg carry;
    reg negative;
    reg overflow;
    wire [31:0] a_signed;
    wire [31:0] b_signed;
    assign a_signed = $signed(a);
    assign b_signed = $signed(b);
    wire [31:0] res_signed;
    assign res_signed = res[31] ? $signed({~res[31], res[31:0]}) : res;
    always @(*) begin
        case (aluc)
            ADD: res = a_signed + b_signed;
            ADDU: res = {a_signed[31], res_signed[31:0]};
            SUB: res = a_signed - b_signed;
            SUBU: res = {a_signed[31], res_signed[31:0]};
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: begin
                res = (a_signed < b_signed) ? 1 : 0;
                flag = 1;
            end
            SLTU: begin
                res = (a < b) ? 1 : 0;
                flag = 1;
            end
            SLL: res = a << b;
            SRL: res = a >> b;
            SRA: res = $signed(a) >>> b;
            SLLV: res = a << b_signed;
            SRLV: res = a >> b_signed;
            SRAV: res = $signed(a) >>> b_signed;
            LUI: res = {16'h0000, a[31:16]};
            default: res = 32'hz;
        endcase
        zero = (res == 32'h00000000) ? 1 : 0;
        carry = (aluc == ADD) ? (b[31] & a[31]) : (aluc == SUB) ? ~(b[31] & a[31]) : 0;
        negative = (res[31] == 1) ? 1 : 0;
        overflow = (aluc == ADD) ? ((a[31] != b[31] && res[31] != a[31]) || (a[31] == b[31] && res[31] != a[31])) : ((aluc == SUB) ? ((a[31] != b[31] && res[31] == a[31]) || (a[31] == b[31] && res[31] != a[31])) : 0);
    end
    assign flag = (flag == 1) ? 1 : 0;
endmodule