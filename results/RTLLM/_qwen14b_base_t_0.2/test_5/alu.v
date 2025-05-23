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
        r = 32'b0;
        zero = 1'b0;
        carry = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                res = a + b;
                carry = (res[31:0] != {a[31:0] + b[31:0]});
                overflow = (a[31] == b[31]) && (a[31] != res[31]);
                negative = res[31];
                zero = (res == 32'b0);
            end
            ADDU: begin
                res = a + b;
                carry = (res[31:0] != {a[31:0] + b[31:0]});
                negative = res[31];
                zero = (res == 32'b0);
            end
            SUB: begin
                res = a - b;
                carry = (res[31:0] != {a[31:0] - b[31:0]});
                overflow = (a[31] != b[31]) && (a[31] != res[31]);
                negative = res[31];
                zero = (res == 32'b0);
            end
            SUBU: begin
                res = a - b;
                carry = (res[31:0] != {a[31:0] - b[31:0]});
                negative = res[31];
                zero = (res == 32'b0);
            end
            AND: begin
                res = a & b;
                negative = res[31];
                zero = (res == 32'b0);
            end
            OR: begin
                res = a | b;
                negative = res[31];
                zero = (res == 32'b0);
            end
            XOR: begin
                res = a ^ b;
                negative = res[31];
                zero = (res == 32'b0);
            end
            NOR: begin
                res = ~(a | b);
                negative = res[31];
                zero = (res == 32'b0);
            end
            SLT: begin
                res = $signed(a) < $signed(b);
                flag = res[0];
                negative = res[31];
                zero = (res == 32'b0);
            end
            SLTU: begin
                res = a < b;
                flag = res[0];
                negative = res[31];
                zero = (res == 32'b0);
            end
            SLL: begin
                res = a << b[4:0];
                negative = res[31];
                zero = (res == 32'b0);
            end
            SRL: begin
                res = a >> b[4:0];
                negative = res[31];
                zero = (res == 32'b0);
            end
            SRA: begin
                res = $signed(a) >>> b[4:0];
                negative = res[31];
                zero = (res == 32'b0);
            end
            SLLV: begin
                res = a << b[4:0];
                negative = res[31];
                zero = (res == 32'b0);
            end
            SRLV: begin
                res = a >> b[4:0];
                negative = res[31];
                zero = (res == 32'b0);
            end
            SRAV: begin
                res = $signed(a) >>> b[4:0];
                negative = res[31];
                zero = (res == 32'b0);
            end
            LUI: begin
                res = {a[15:0], 16'b0};
                negative = res[31];
                zero = (res == 32'b0);
            end
            default: begin
                // Do nothing, result is 0
            end
        endcase

        r = res[31:0];
    end
endmodule