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
        case (aluc)
            6'b100000: // ADD
                r <= a + b;
            6'b100001: // ADDU
                r <= a + b + 1;
            6'b100010: // SUB
                r <= a - b;
            6'b100011: // SUBU
                r <= a - b - 1;
            6'b100100: // AND
                r <= a & b;
            6'b100101: // OR
                r <= a | b;
            6'b100110: // XOR
                r <= a ^ b;
            6'b100111: // NOR
                r <= ~(a & b);
            6'b101010: // SLT
                zero <= (a == b);
            6'b101011: // SLTU
                carry <= (a > b);
            6'b101100: // SLL
                r <= a << b;
            6'b101101: // SRL
                r <= a >> b;
            6'b101110: // SRA
                r <= a >>> b;
            6'b101111: // LUI
                r <= a + 1;
            default: // 'z' (high-impedance)
                r <= 0;
        endcase
    endfunction