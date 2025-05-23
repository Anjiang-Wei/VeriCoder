module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);
    parameter ADD = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND = 6'b100100;
    parameter OR = 6'b100101;
    parameter XOR = 6'b100110;
    parameter NOR = 6'b100111;
    parameter SLT = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL = 6'b000000;
    parameter SRL = 6'b000010;
    parameter SRA = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI = 6'b001111;

    reg signed [31:0] res;
    wire [31:0] a_signed, b_signed;
    assign a_signed = {a[31], a[30:0]};
    assign b_signed = {b[31], b[30:0]};

    assign zero = (res == 32'd0);
    assign carry = ((res > 32'd2147483647) || (res < -32'd2147483648));
    assign negative = (res[31]);
    assign overflow = ((a[31] ^ b[31]) && ((res[31] != a[31]) || (res[31] != b[31])));
    assign flag = ((aluc == SLT) || (aluc == SLTU)) ? 1'b1 : 1'bz;

    always @(*)
        case(aluc)
            ADD: res <= a_signed + b_signed;
            ADDU: res <= a + b;
            SUB: res <= a_signed - b_signed;
            SUBU: res <= a - b;
            AND: res <= a_signed & b_signed;
            OR: res <= a_signed | b_signed;
            XOR: res <= ^a_signed & ^b_signed;
            NOR: res <= ~((a_signed | b_signed));
            SLT: res <= ((a_signed < b_signed) ? 32'd1 : 32'd0);
            SLTU: res <= (a < b) ? 32'd1 : 32'd0;
            SLL: res <= {32'd0, a[31:0] << aluc[4:0]};
            SRL: res <= (aluc == LUI) ? 16'd65535<<16 : {32'd0, b_signed >> aluc[4:0]};
            SRA: res <= {32'd0, b_signed >>> aluc[4:0]};
            SLLV: res <= {32'd0, a << b[4:0]};
            SRLV: res <= (aluc == LUI) ? 16'd65535<<16 : {32'd0, b >> b[4:0]};
            SRAV: res <= {32'd0, b >>> b[4:0]};
            LUI: res <= {{16{a[15]}}, a[15:0]};
            default: res <= 32'bz;
        endcase

    assign r = res[31:0];

endmodule