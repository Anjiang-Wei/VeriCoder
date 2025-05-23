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

    wire signed [31:0] sa, sb;
    reg [31:0] res;
    reg flag_reg;

    assign sa = a;
    assign sb = b;
    assign r = res[31:0];
    assign zero = (res == 32'b0);
    assign carry = 1'b0; // Carry not implemented in this simple ALU
    assign negative = res[31];
    assign overflow = 1'b0; // Overflow not implemented in this simple ALU
    assign flag = flag_reg;

    always @(*) begin
        case(aluc)
            ADD: res = sa + sb;
            ADDU: res = a + b;
            SUB: res = sa - sb;
            SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = (sa < sb) ? 32'd1 : 32'd0;
            SLTU: res = (a < b) ? 32'd1 : 32'd0;
            SLL: res = a << b[4:0];
            SRL: res = a >> b[4:0];
            SRA: res = a >>> b[4:0]; // Arithmetic right shift
            SLLV: res = a << b[4:0];
            SRLV: res = a >> b[4:0];
            SRAV: res = a >>> b[4:0]; // Arithmetic right shift
            LUI: res = {a[15:0], 16'b0};
            default: res = 32'bz; // High-impedance if aluc is undefined
        endcase
        flag_reg = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;
    end

endmodule