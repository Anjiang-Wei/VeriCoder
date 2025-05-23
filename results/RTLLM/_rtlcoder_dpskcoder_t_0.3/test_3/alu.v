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
    wire [31:0] a_ext;
    wire [31:0] b_ext;
    wire [31:0] a_neg;
    wire [31:0] b_neg;
    wire [31:0] a_neg_ext;
    wire [31:0] b_neg_ext;
    wire [31:0] a_neg_shift;
    wire [31:0] b_neg_shift;
    wire [31:0] a_neg_shift_ext;
    wire [31:0] b_neg_shift_ext;
    wire [31:0] a_neg_shift_neg;
    wire [31:0] b_neg_shift_neg;
    wire [31:0] a_neg_shift_neg_ext;
    wire [31:0] b_neg_shift_neg_ext;
    wire [31:0] a_neg_shift_neg_ext_neg;
    wire [31:0] b_neg_shift_neg_ext_neg;
    wire [31:0] a_neg_shift_neg_ext_neg_ext;
    wire [31:0] b_neg_shift_neg_ext_neg_ext;
    wire [31:0] a_neg_shift_neg_ext_neg_ext_neg;
    wire [31:0] b_neg_shift_neg_ext_neg_ext_neg;
    wire [31:0] a_neg_shift_neg_ext_neg_ext_neg_ext;
    wire [31:0] b_neg_shift_neg_ext_neg_ext_neg_ext;
    wire [31:0] a_neg_shift_neg_ext_neg_ext_neg_ext_ext;
    wire [31:0] b_neg_shift_neg_ext_neg_ext_neg_ext_ext;
    wire [31:0] a_neg_shift_neg_ext_neg_ext_neg_ext_ext_ext;
    wire [31:0] b_neg_shift_neg_ext_neg_ext_neg_ext_ext_ext;
    wire [31:0] a_neg_shift_neg_ext_neg_ext_neg_ext_ext_ext_ext;
    wire [31:0] b_neg_shift_neg_ext_neg_ext_neg_ext_ext_ext_ext;
    wire [31:0] a_neg_shift_neg_ext_neg_ext_neg_ext_ext_ext_ext_ext;
    wire [