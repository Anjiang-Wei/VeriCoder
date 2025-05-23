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
    wire [31:0] a_signed = $signed(a);
    wire [31:0] b_signed = $signed(b);

    assign r = res;
    assign zero = (res == 32'b0);
    assign negative = res[31];
    assign carry = (aluc == ADD) | (aluc == ADDU);
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;

    always @(*) begin
        case (aluc)
            ADD: res = a_signed + b_signed;
            ADDU: res = a + b;
            SUB: res = a_signed - b_signed;
            SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            SLTU: res = (a < b) ? 32'b1 : 32'b0;
            SLL: res = a << b[4:0];
            SRL: res = a >> b[4:0];
            SRA: res = $signed(a) >>> b[4:0];
            SLLV: res = a << b_signed[4:0];
            SRLV: res = a >> b_signed[4:0];
            SRAV: res = $signed(a) >>> b_signed[4:0];
            LUI: res = {b[15:0], 16'b0};
            default: res = 32'bz;
        endcase
    end

    assign overflow = (aluc == ADD) & 
                     ((a[31] == b[31]) & (a[31] != res[31])) | 
                     (aluc == SUB) & 
                     ((a[31] != b[31]) & (a[31] != res[31]));
endmodule