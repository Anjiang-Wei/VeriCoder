Please implement the alu module according to the above requirements.

```verilog
    reg [31:0] res;
    wire signed [31:0] ina, inb;
    wire [4:0] sh_amt;
    assign ina = a;
    assign inb = b;
    assign r = res[31:0];
    assign zero = ~|r;
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;

    always @* begin
        case(aluc)
            ADD: res = ina + inb;
            ADDU: res = ina + inb;
            SUB: res = ina - inb;
            SUBU: res = ina - inb;
            AND: res = ina & inb;
            OR: res = ina | inb;
            XOR: res = ina ^ inb;
            NOR: res = ~(ina | inb);
            SLT: res = (ina < inb) ? 32'b1 : 32'b0;
            SLTU: res = (ina < inb) ? 32'b1 : 32'b0;
            SLL: res = ina << inb[4:0];
            SRL: res = ina >> inb[4:0];
            SRA: res = $signed(ina) >>> inb[4:0];
            SLLV: res = ina << sh_amt;
            SRLV: res = ina >> sh_amt;
            SRAV: res = $signed(ina) >>> sh_amt;
            LUI: res = {b[15:0], 16'b0};
            default: res = 32'bz;
        endcase
    end

    assign carry = (aluc == ADD || aluc == ADDU) ? res[32] :
                   (aluc == SUB || aluc == SUBU) ? ~res[32] : 1'bz;
    assign negative = res[31];
    assign overflow = (aluc == ADD) ? ((ina[31] == inb[31]) && (ina[31] != res[31])) :
                      (aluc == SUB) ? ((ina[31] != inb[31]) && (ina[31] != res[31])) : 1'bz;
    assign sh_amt = ina[4:0];
endmodule