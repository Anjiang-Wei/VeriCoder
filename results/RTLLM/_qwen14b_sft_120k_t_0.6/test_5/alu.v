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

    wire signed [31:0] a_s, b_s;
    reg signed [31:0] res;
    reg [31:0] shift_amount;

    assign a_s = a;
    assign b_s = b;
    assign r = res[31:0];
    assign zero = (res == 32'b0);
    assign carry = res[32];
    assign negative = res[31];
    assign overflow = (aluc == ADD || aluc == ADDU) && (a_s[31] == b_s[31]) && (res[31] != a_s[31]);
    assign flag = (aluc == SLT || aluc == SLTU);

    always @(*) begin
        case(aluc)
            ADD:  res = a_s + b_s;
            ADDU: res = a + b;
            SUB:  res = a_s - b_s;
            SUBU: res = a - b;
            AND:  res = a & b;
            OR:   res = a | b;
            XOR:  res = a ^ b;
            NOR:  res = ~(a | b);
            SLT:  res = (a_s < b_s) ? 32'd1 : 32'd0;
            SLTU: res = (a < b) ? 32'd1 : 32'd0;
            SLL:  res = a_s << b[4:0];
            SRL:  res = a_s >>> b[4:0];
            SRA:  res = a_s >> b[4:0];
            SLLV: res = a_s << b[4:0];
            SRLV: res = a_s >>> b[4:0];
            SRAV: res = a_s >> b[4:0];
            LUI:  res = {a[15:0], 16'b0};
            default: res = 32'bz;
        endcase
    end
endmodule