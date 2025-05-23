wire [31:0] a_signed = a[31] ? -a : a;
    wire [31:0] b_signed = b[31] ? -b : b;
    wire [31:0] res;
    wire [31:0] shift_amt;

    // Determine the shift amount
    assign shift_amt = aluc inside {SLLV, SRLV, SRAV} ? a[4:0] : b[4:0];

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
            SLT: res = a_signed < b_signed;
            SLTU: res = a < b;
            SLL: res = a << shift_amt;
            SRL: res = a >> shift_amt;
            SRA: res = $signed(a) >>> shift_amt;
            SLLV: res = a << shift_amt;
            SRLV: res = a >> shift_amt;
            SRAV: res = $signed(a) >>> shift_amt;
            LUI: res = {16'b0, a[15:0]};
            default: res = 32'bz;
        endcase
    end

    assign r = res;
    assign zero = (res == 32'b0);
    assign carry = (res[31] == 1'b0);
    assign negative = (res[31] == 1'b1);
    assign overflow = (res[31] != a[31] && res[31] != b[31]);
    assign flag = (aluc inside {SLT, SLTU});
endmodule