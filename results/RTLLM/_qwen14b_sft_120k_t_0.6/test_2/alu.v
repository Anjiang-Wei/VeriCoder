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
    wire signed [31:0] a_signed, b_signed;
    wire signed [32:0] sum_signed;
    wire unsigned [32:0] sum_unsigned;
    wire [4:0] shift_amount;

    assign a_signed = a;
    assign b_signed = b;
    assign sum_signed = {1'b0, a_signed} + {1'b0, b_signed};
    assign sum_unsigned = {1'b0, a} + {1'b0, b};
    assign shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : 5'd0;

    // Assign outputs
    assign r = res[31:0];
    assign zero = (res == 32'b0);
    assign carry = sum_unsigned[32];
    assign negative = res[31];
    assign overflow = (sum_signed[31] == sum_unsigned[31]) && (sum_signed[31] != res[31]);
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bx;

    always @(*) begin
        case(aluc)
            ADD: res = sum_signed[31:0];
            ADDU: res = sum_unsigned[31:0];
            SUB: res = sum_signed[31:0];
            SUBU: res = sum_unsigned[31:0];
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: res = (a_signed < b_signed) ? 32'd1 : 32'd0;
            SLTU: res = (a < b) ? 32'd1 : 32'd0;
            SLL: res = a << shift_amount;
            SRL: res = a >>> shift_amount;
            SRA: res = a >> shift_amount;
            SLLV: res = a << b[4:0];
            SRLV: res = a >>> b[4:0];
            SRAV: res = a >> b[4:0];
            LUI: res = {16'd0, a[15:0]};
            default: res = 32'bx;
        endcase
    end
endmodule