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

    wire [31:0] res;
    wire [4:0] shift_amount;
    wire [31:0] shifted_b;
    wire [31:0] shifted_a;
    wire [31:0] shifted_res;
    wire [31:0] shifted_carry;
    wire [31:0] shifted_overflow;
    wire [31:0] shifted_negative;
    wire [31:0] shifted_zero;
    wire [31:0] shifted_flag;
    wire [31:0] shifted_a_msb;
    wire [31:0] shifted_b_msb;
    wire [31:0] shifted_res_msb;
    wire [31:0] shifted_carry_msb;
    wire [31:0] shifted_overflow_msb;
    wire [31:0] shifted_negative_msb;
    wire [31:0] shifted_zero_msb;
    wire [31:0] shifted_flag_msb;
    wire [31:0] shifted_a_lsb;
    wire [31:0] shifted_b_lsb;
    wire [31:0] shifted_res_lsb;
    wire [31:0] shifted_carry_lsb;
    wire [31:0] shifted_overflow_lsb;
    wire [31:0] shifted_negative_lsb;
    wire [31:0] shifted_zero_lsb;
    wire [31:0] shifted_flag_lsb;
    wire [31:0] shifted_a_msb_lsb;
    wire [31:0] shifted_b_msb_lsb;
    wire [31:0] shifted_res_msb_lsb;
    wire [31:0] shifted_carry_msb_lsb;
    wire [31:0] shifted_overflow_msb_lsb;
    wire [31:0] shifted_negative_msb_lsb;
    wire [31:0] shifted_zero_msb_lsb;
    wire [31:0] shifted_flag_msb_lsb;

    assign res = {32{1'bz}};
    assign shift_amount = (aluc == SLL || aluc == SLLV) ? a[4:0] : (aluc == SRL || aluc == SRLV) ? b[4:0] : a[4:0];
    assign shifted_b = (aluc == SLL || aluc == SLLV) ? {b, 32'b0} : (aluc == SRL || aluc == SRLV) ? {32'b0, b} : b;