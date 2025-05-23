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

input [31:0] a, b; // input operands
input [5:0] aluc; // control signal for selecting the operation to be performed
output [31:0] r; // output result
output zero; // output indicating whether the result is zero
output carry; // output indicating whether a carry occurred during the operation
output negative; // output indicating whether the result is negative
output overflow; // output indicating whether an overflow occurred during the operation
output flag; // output representing a general flag, which is set based on specific operations (SLT and SLTU)

wire [31:0] res; // result of the operation
wire zero_flag; // output indicating whether the result is all zeros
wire carry_flag; // output indicating whether a carry occurred during the operation
wire negative_flag; // output indicating whether the result is negative
wire overflow_flag; // output indicating whether an overflow occurred during the operation
wire flag_flag; // output representing a general flag, which is set based on specific operations (SLT and SLTU)

always @* begin
    case (aluc)
        6'b100000: // ADD
            res = a + b;
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b100001: // ADDU
            res = a + b + (a == 0 || b == 0);
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b100010: // SUB
            res = a - b;
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b100011: // SUBU
            res = a - b - (a == 0 || b == 0);
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b100100: // AND
            res = a & b;
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b100101: // OR
            res = a | b;
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b100110: // XOR
            res = a ^ b;
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b100111: // NOR
            res = ~(a | b);
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b101010: // SLT
            res = a > b;
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b101011: // SLTU
            res = a > b + (a == 0 || b == 0);
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b101100: // SLL
            res = a << b;
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b101101: // SRL
            res = a >> b;
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b101110: // SRA
            res = a >> b + (a == 0 || b == 0);
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
        6'b101111: // LUI
            res = a + (a == 0 || b == 0);
            zero_flag = (a == 0 || b == 0);
            carry_flag = 0;
            negative_flag = 0;
            overflow_flag = 0;
            flag_flag = 0;
    endcase
end