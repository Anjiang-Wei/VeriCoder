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
    wire [32:0] res_ext;
    wire [4:0] shift_amt;
    wire [31:0] a_ext, b_ext;
    wire [31:0] a_signed, b_signed;
    wire [31:0] a_unsigned, b_unsigned;
    wire [31:0] a_neg, b_neg;
    wire [31:0] a_neg_ext, b_neg_ext;
    wire [31:0] a_unsigned_ext, b_unsigned_ext;
    wire [31:0] a_signed_ext, b_signed_ext;
    wire [31:0] a_neg_signed_ext, b_neg_signed_ext;
    wire [31:0] a_neg_unsigned_ext, b_neg_unsigned_ext;
    wire [31:0] a_unsigned_neg_ext, b_unsigned_neg_ext;
    wire [31:0] a_signed_neg_ext, b_signed_neg_ext;
    wire [31:0] a_neg_signed_neg_ext, b_neg_signed_neg_ext;
    wire [31:0] a_neg_unsigned_neg_ext, b_neg_unsigned_neg_ext;
    wire [31:0] a_unsigned_neg_neg_ext, b_unsigned_neg_neg_ext;
    wire [31:0] a_signed_neg_neg_ext, b_signed_neg_neg_ext;
    wire [31:0] a_neg_signed_neg_neg_ext, b_neg_signed_neg_neg_ext;
    wire [31:0] a_neg_unsigned_neg_neg_ext, b_neg_unsigned_neg_neg_ext;
    wire [31:0] a_unsigned_neg_neg_neg_ext, b_unsigned_neg_neg_neg_ext;
    wire [31:0] a_signed_neg_neg_neg_ext, b_signed_neg_neg_neg_ext;
    wire [31:0] a_neg_signed_neg_neg_neg_ext, b_neg_signed_neg_neg_neg_ext;
    wire [31:0] a_neg_unsigned_neg_neg_neg_ext, b_neg_unsigned_neg_neg_neg_ext;
    wire [31:0] a_unsigned_neg_neg_neg_neg_ext, b_unsigned_neg_neg_neg_neg_ext;
    wire [31:0] a_signed_neg_neg_neg_neg_ext, b_s