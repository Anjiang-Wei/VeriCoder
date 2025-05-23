module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
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

    always @(*) begin
        r = 0;
        zero = 0;
        carry = 0;
        negative = 0;
        overflow = 0;
        flag = 0;

        case (aluc)
            ADD: begin
                res = a + b;
                carry = res[31];
                negative = res[31];
                overflow = (a[30:0] == b[30:0] && a[30:0] != res[30:0]);
                r = res;
            end
            ADDU: begin
                res = a + b;
                carry = res[31];
                negative = res[31];
                r = res;
            end
            SUB: begin
                res = a - b;
                carry = ~b[31];
                negative = res[31];
                overflow = (a[30:0] == b[30:0] && a[30:0] != res[30:0]);
                r = res;
            end
            SUBU: begin
                res = a - b;
                carry = ~b[31];
                negative = res[31];
                r = res;
            end
            AND: begin
                r = a & b;
            end
            OR: begin
                r = a | b;
            end
            XOR: begin
                r = a ^ b;
            end
            NOR: begin
                r = ~(a | b);
            end
            SLT: begin
                flag = (a < b);
                r = flag;
            end
            SLTU: begin
                flag = (a < b);
                r = flag;
            end
            SLL: begin
                r = a << b[4:0];
            end
            SRL: begin
                r = a >> b[4:0];
            end
            SRA: begin
                r = {{5{a[31]}}, a[31:5]} >> b[4:0];
            end
            SLLV: begin
                r = a << b[4:0];
            end
            SRLV: begin
                r = a >> b[4:0];
            end
            SRAV: begin
                r = {{5{a[31]}}, a[31:5]} >> b[4:0];
            end
            LUI: begin
                r = {a[15:0], 16'b0};
            end
            default: begin
                r = 0;
            end
        endcase

        zero = (r == 0);
    end
endmodule