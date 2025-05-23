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

    // Define parameters
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

    // Define output variables
    wire [31:0] r, zero, carry, negative, overflow, flag;

    // Instantiate inputs
    input [31:0] a, b;

    // Conditional statement to perform appropriate operation based on control signal
    case (aluc)
       ADD: begin
            r = a + b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x1000000;
            flag = SLT;
       end
       ADDU: begin
            r = a + b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x1000000;
            flag = SLTU;
       end
       SUB: begin
            r = a - b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x1000000;
            flag = SLT;
       end
       SUBU: begin
            r = a - b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = SLTU;
       end
       AND: begin
            r = a & b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = SLT;
       end
       OR: begin
            r = a | b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = SLT;
       end
       XOR: begin
            r = a ^ b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = SLT;
       end
       NOR: begin
            r = ~(a | b);
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = SLT;
       end
       SLT: begin
            r = a ^ b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = LUI;
       end
       SLTU: begin
            r = a ^ b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = LUI;
       end
       SLL: begin
            r = a << b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = SLT;
       end
       SRL: begin
            r = a >> b;
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = SLT;
       end
       SRA: begin
            r = a ^ (a >> b);
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = SLT;
       end
       LUI: begin
            r = ~(a | b);
            zero = ~(a | b);
            carry = a[31] & b[31];
            negative = a < b;
            overflow = a > 0x100000;
            flag = LUI;
       end
    endcase

    // Instantiate output variables
    assign zero = r & 0x8000000;
    assign carry = r & 0x4000000;
    assign negative = r & 0x2000000;
    assign overflow = r & 0x1000000;
    assign flag = SLT;

endmodule