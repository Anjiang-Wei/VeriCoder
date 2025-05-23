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

    always @* begin
        case (aluc) matches({
            ADD: begin
                r <= a + b;
                zero <= a == 0 || b == 0;
                carry <= a < b;
                negative <= a < 0;
                overflow <= a > 31;
                flag <= SLT[a[4:0]]. boolean'event();
            end,
            SUB: begin
                r <= a - b;
                zero <= a == 0 || b == 0;
                carry <= a < b;
                negative <= a < 0;
                overflow <= a > 31;
                flag <= SLT[a[4:0]]. boolean'event();
            end,
            SUBU: begin
                r <= a - b + 32;
                zero <= a == 0 || b == 0;
                carry <= a < b;
                negative <= a < 0;
                overflow <= a > 31;
                flag <= SLT[a[4:0]]. boolean'event();
            end,
            AND: begin
                r <= a & b;
                zero <= a == 0 || b == 0;
                carry <= a < b;
                negative <= a < 0;
                overflow <= a > 31;
                flag <= SLT[a[4:0]]. boolean'event();
            end,
            OR: begin
                r <= a | b;
                zero <= a == 0 || b == 0;
                carry <= a < b;
                negative <= a < 0;
                overflow <= a > 31;
                flag <= SLT[a[4:0]]. boolean'event();
            end,
            XOR: begin
                r <= a ^ b;
                zero <= a == 0 || b == 0;
                carry <= a < b;
                negative <= a < 0;
                overflow <= a > 31;
                flag <= SLT[a[4:0]]. boolean'event();
            end,
            NOR: begin
                r <= ~(a | b);
                zero <= a == 0 || b == 0;
                carry <= a < b;
                negative <= a < 0;
                overflow <= a > 31;
                flag <= SLT[a[4:0]]. boolean'event();
            end,
            LUI: begin
                r <= a;
                zero <= a == 0;
                carry <= a < 0;
                negative <= a < 0;
                overflow <= a > 31;
                flag <= SLT[a[4:0]]. boolean'event();
            end)
        });
    end