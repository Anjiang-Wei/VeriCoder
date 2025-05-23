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

    wire [31:0] signed_a, signed_b;
    reg [31:0] res;
    reg zero_flag, carry_flag, negative_flag, overflow_flag, flag_out;

    assign signed_a = a;
    assign signed_b = b;
    assign r = res[31:0];
    assign zero = zero_flag;
    assign carry = carry_flag;
    assign negative = negative_flag;
    assign overflow = overflow_flag;
    assign flag = flag_out;

    always @(*) begin
        case (aluc)
            ADD: begin
                res = signed_a + signed_b;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = (signed_a[30:0] == signed_b[30:0]) &&
                                (signed_a[30:0] == res[30:0]);
            end
            ADDU: begin
                res = a + b;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            SUB: begin
                res = signed_a - signed_b;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = (signed_a[30:0] == signed_b[30:0]) &&
                                (signed_a[30:0] == res[30:0]);
            end
            SUBU: begin
                res = a - b;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            AND: begin
                res = a & b;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            OR: begin
                res = a | b;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            XOR: begin
                res = a ^ b;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            NOR: begin
                res = ~(a | b);
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            SLT: begin
                res = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
                flag_out = 1'b1;
            end
            SLTU: begin
                res = (a < b) ? 32'b1 : 32'b0;
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
                flag_out = 1'b1;
            end
            SLL: begin
                res = a << b[4:0];
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            SRL: begin
                res = a >> b[4:0];
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            SRA: begin
                res = $signed(a) >>> b[4:0];
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            SLLV: begin
                res = a << b[4:0];
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            SRLV: begin
                res = a >> b[4:0];
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            SRAV: begin
                res = $signed(a) >>> b[4:0];
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            LUI: begin
                res = {a[15:0], 16'b0};
                zero_flag = (res == 32'b0);
                carry_flag = 1'b0;
                negative_flag = (res[31] == 1'b1);
                overflow_flag = 1'b0;
            end
            default: begin
                res = 32'bx;
                zero_flag = 1'bx;
                carry_flag = 1'bx;
                negative_flag = 1'bx;
                overflow_flag = 1'bx;
                flag_out = 1'bx;
            end
        endcase
    end

endmodule