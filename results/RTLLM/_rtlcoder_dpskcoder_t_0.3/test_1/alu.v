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
    wire [31:0] a_signed, b_signed;
    wire [4:0] shift_amount;
    wire [31:0] shifted_a, shifted_b;
    wire [31:0] shifted_res;
    wire [31:0] shifted_a_signed, shifted_b_signed;
    wire [31:0] shifted_res_signed;
    wire [31:0] shifted_res_unsigned;
    wire [31:0] shifted_res_signed_neg;
    wire [31:0] shifted_res_unsigned_neg;
    wire [31:0] shifted_res_signed_pos;
    wire [31:0] shifted_res_unsigned_pos;
    wire [31:0] shifted_res_signed_zero;
    wire [31:0] shifted_res_unsigned_zero;
    wire [31:0] shifted_res_signed_overflow;
    wire [31:0] shifted_res_unsigned_overflow;
    wire [31:0] shifted_res_signed_carry;
    wire [31:0] shifted_res_unsigned_carry;
    wire [31:0] shifted_res_signed_neg_overflow;
    wire [31:0] shifted_res_unsigned_neg_overflow;
    wire [31:0] shifted_res_signed_pos_overflow;
    wire [31:0] shifted_res_unsigned_pos_overflow;
    wire [31:0] shifted_res_signed_zero_overflow;
    wire [31:0] shifted_res_unsigned_zero_overflow;
    wire [31:0] shifted_res_signed_carry_overflow;
    wire [31:0] shifted_res_unsigned_carry_overflow;
    wire [31:0] shifted_res_signed_neg_carry_overflow;
    wire [31:0] shifted_res_unsigned_neg_carry_overflow;
    wire [31:0] shifted_res_signed_pos_carry_overflow;
    wire [31:0] shifted_res_unsigned_pos_carry_overflow;
    wire [31:0] shifted_res_signed_zero_carry_overflow;
    wire [31:0] shifted_res_unsigned_zero_carry_overflow;
    wire [31:0] shifted_res_signed_neg_zero_overflow;
    wire [31:0] shifted_res_unsigned_neg_zero_overflow;
    wire [31:0] shifted_res_signed_pos_zero_overflow;
    wire [31:0] shifted