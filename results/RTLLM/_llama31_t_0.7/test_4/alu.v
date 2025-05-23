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

reg signed [31:0] res;
reg [1:0] sign;

always @ (*)
begin
    // Determine the signs of operands a and b
    sign[0] = (a[31] == '1') ? '1' : '0';
    sign[1] = (b[31] == '1') ? '1' : '0';

    case (aluc)
        ADD: begin
            res = a + b;
        end

        ADDU: begin
            res = {a[31], a[30:0] + b[30:0]};
        end

        SUB: begin
            if (sign == 2'b10) // Negative overflow
                res = $signed'{1, -2**32};
            else
                res = a - b;
        end

        SUBU: begin
            if (a < b)
                res = {a[31], a[30:0] + (32'd-1)};
            else
                res = a - b;
        end

        AND: begin
            res = a & b;
        end

        OR: begin
            res = a | b;
        end

        XOR: begin
            res = a ^ b;
        end

        NOR: begin
            res = ~ (a | b);
        end

        SLT: begin
            if ((a[31] == '0' && b[31] == '1') || (a < b))
                flag = 1'b1; // Set flag for true result
            else
                flag = 1'b0;
        end

        SLTU: begin
            if (a < b)
                flag = 1'b1; // Set flag for true result
            else
                flag = 1'b0;
        end

        SLL: begin
            res = {a[31], a << aluc[4:0]};
        end

        SRL: begin
            if (a < 0)
                res = {{res[30:0] signed}[1'd-1], res >> aluc[4:0]};
            else
                res = {a[31], a >> aluc[4:0]};
        end

        SRA: begin
            if (a < 0) // Arithmetic right shift
                res = {{res[30:0] signed}[1'd-1], res >> aluc[4:0]};
            else
                res = {a[31], a >> aluc[4:0]};
        end

        SLLV: begin
            if (b < 0)
                res = {a[31], a << b};
            else
                res = {a[31], a << b[4:0]};
        end

        SRLV: begin
            if ((b < 0 && a < 0) || (a >= 0))
                res = {{res[30:0] signed}[1'd-1], res >> b[4:0]};
            else
                res = {a[31], a >> b[4:0]};
        end

        SRAV: begin
            if ((b < 0 && a < 0) || (a >= 0))
                res = {{res[30:0] signed}[1'd-1], res >> b[4:0]};
            else
                res = {a[31], a >> b[4:0]};
        end

        LUI: begin
            // Concatenate upper bits of operand with zeros (assuming 32-bit)
            res = {b, 16'd0};
        end

        default: begin
            flag = 1'b0;
            res = 0; // Default value for unknown opcodes
        end
    endcase

    if (res[31] == '1') // Check sign of result for overflow indication
        negative = 1'b1;

    zero = (res == 0);
end

assign r = res;
assign flag = flag;

endmodule