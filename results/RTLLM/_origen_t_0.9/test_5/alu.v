Please implement the above-mentioned Verilog module 'alu' to perform the following operations:
- Addition (ADD)
- Addition unsigned (ADDU)
- Subtraction (SUB)
- Subtraction unsigned (SUBU)
- Bitwise AND (AND)
- Bitwise OR (OR)
- Bitwise XOR (XOR)
- Bitwise NOR (NOR)
- Set less than (SLT)
- Set less than unsigned (SLTU)
- Shift left logical (SLL)
- Shift right logical (SRL)
- Shift right arithmetic (SRA)
- Shift left logical variable (SLLV)
- Shift right logical variable (SRLV)
- Shift right arithmetic variable (SRAV)
- Load upper immediate (LUI)

Your implementation should be contained within a single module of no more than 200 lines of Verilog code.


Please complete the Verilog code below and return the complete module code directly:
```verilog
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

    assign r = res[31:0];
    assign zero = (r == 32'b0);
    assign carry = res[32];
    assign negative = r[31];
    assign overflow = (a[31] == b[31]) && (a[31] != r[31]);
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;

    reg [33:0] res;
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    always @(*) begin
        case(aluc)
            ADD: res = {1'b0, a} + {1'b0, b};
            ADDU: res = a + b;
            SUB: res = {1'b0, a} - {1'b0, b};
            SUBU: res = a - b;
            AND: res = {1'b0, a & b};
            OR: res = {1'b0, a | b};
            XOR: res = {1'b0, a ^ b};
            NOR: res = {1'b0, ~(a | b)};
            SLT: res = {1'b0, a_signed < b_signed};
            SLTU: res = {1'b0, a < b};
            SLL: res = {a, 1'b0};
            SLLV: res = {a, 1'b0} << b[4:0];
            SRL: res = {1'b0, a >> 1};
            SRLV: res = {1'b0, a >> b[4:0]};
            SRA: res = {{1'b0, a[31]}, a[31:1]