### Response:
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

    reg [31:0] res;
    wire [31:0] a1, b1;

    assign a1 = a;
    assign b1 = b;
    assign r = res;
    assign zero = (res == 32'b0);
    assign negative = res[31];

    assign carry = (aluc == ADD) ? (a1[31] & ~b1[31]) | (~a1[31] & b1[31]) :
                   (aluc == ADDU) ? (a1[31] & ~b1[31]) | (~a1[31] & b1[31]) :
                   (aluc == SUB) ? (~a1[31] & b1[31]) | (a1[31] & ~b1[31]) :
                   (aluc == SUBU) ? (~a1[31] & b1[31]) | (a1[31] & ~b1[31]) :
                   (aluc == SLL) ? (res[31] & a1[10]) | (res[30:0] & a1[9:0]) :
                   (aluc == SRL) ? (res[31:1] & a1[4:0]) | (res[0] & a1[10]) :
                   (aluc == SRA) ? (res[31:1] & a1[4:0]) | (res[0] & a1[10]) :
                   (aluc == SLLV) ? (res[31] & a1[4]) | (res[30:0] & a1[3:0]) :
                   (aluc == SRLV) ? (res[31:1] & a1[3:0]) | (res[0] & a1[4]) :
                   (aluc == SRAV) ? (res[31:1] & a1[3:0]) | (res[0] & a1[4]) :
                   'z;

    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;

    always @(*) begin
        case(aluc)
            ADD:  res = a1 + b1;
            ADDU: res = a1 + b1;
            SUB:  res = a1 - b1;
            SUBU: res = a1 - b1;
            AND:  res = a1 & b1;
            OR:   res = a1 | b1;
            XOR:  res = a1 ^ b1;
            NOR:  res = ~(a1 | b1);
            SLT:  res = ($signed(a1) < $signed(b