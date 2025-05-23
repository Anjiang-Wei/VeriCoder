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
    
    reg signed [31:0] a signed;
    reg signed [31:0] b signed;
    reg signed [31:0] r signed;
    reg signed [31:0] res signed;
    reg [31:0] res;
    reg zero;
    reg carry;
    reg negative;
    reg overflow;
    reg flag;
    
    assign r = res[31:0];
    assign zero = (res == 0)? 1'b1 : 1'b0;
    assign carry = (res[31] & ~a[31] & ~b[31]) | (~res[31] & a[31] & b[31]) | (~res[31] & ~a[31] & b[31]);
    assign negative = (res[31] == 1)? 1'b1 : 1'b0;
    assign overflow = (a[31] == b[31] && res[31]!= a[31]) | (a[31]!= b[31] && res[31] == a[31]);
    assign flag = (aluc == SLT || aluc == SLTU)? (a < b)? 1'b1 : (a == b)? 1'b0 : 1'bz : 1'bz;
    
    always @ (aluc or a or b) begin
        case (aluc)
            ADD: res = a + b;
            ADDU: res = a + b;
            SUB: res = a - b;
            SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = (a < b)? 1 : 0;
            SLTU: res = (a < b)? 1 : 0;
            SLL: res = {a[4:0], 5'b0};
            SRL: res = {a[31:5], 5'b0};
            SRA: res = {a[30:5], 5'b0};
            SLLV: res = {a[4:0], 5'b0};
            SRLV: res = {a[31:5], 5'b0};
            SRAV: res = {a[30:5], 5'b0};
            LUI: res = {16'b0, a[15:0]};
            default: res = 32'b0;
        endcase
    end
endmodule