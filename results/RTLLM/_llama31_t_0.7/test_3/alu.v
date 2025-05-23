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

wire signed [31:0] a_s, b_s; // Signed wires for input operands
reg [31:0] res; // Output result register

always @(a or b or aluc)
begin
    case (aluc)
        ADD:
            begin
                res = a + b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= ((res >> 31) != 0);
                overflow <= (((a >> 31) ^ (b >> 31)) ^ ((res >> 31) != 0));
                flag <= 'z;
            end

        ADDU:
            begin
                res = a + b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= ((res >> 31) != 0);
                overflow <= (((a[31] ^ b[31]) ^ ((res >> 31) != 0)) != 0);
                flag <= 'z;
            end

        SUB:
            begin
                res = a - b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= ((~(a[31] ^ b[31]) & (res >> 31)) != 0);
                overflow <= (((a[31] ^ b[31]) ^ ((res >> 31) != 0)) != 0);
                flag <= 'z;
            end

        SUBU:
            begin
                res = a - b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= ((~(a[31] ^ b[31]) & (res >> 31)) != 0);
                overflow <= (((a[31] ^ b[31]) ^ ((res >> 31) != 0)) != 0);
                flag <= 'z;
            end

        AND:
            begin
                res = a & b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        OR:
            begin
                res = a | b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        XOR:
            begin
                res = ^a ^ b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        NOR:
            begin
                res = ~ (a | b);
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        SLT:
            begin
                res = a < b ? a : b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 1'b1;
            end

        SLTU:
            begin
                res = a < b ? a : b;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 1'b1;
            end

        SLL:
            begin
                res = a << b[4:0];
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        SRL:
            begin
                res = a >> b[4:0];
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        SRA:
            begin
                res = a >> b[4:0];
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        SLLV:
            begin
                res = a << b[4:0];
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        SRLV:
            begin
                res = a >> b[4:0];
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        SRAV:
            begin
                res = a >> b[4:0];
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        LUI:
            begin
                res = {{16{b[15]}}, b};
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end

        default:
            begin
                res = 32'd0;
                zero <= (res == 32'd0);
                negative <= ((res & 32'd80000000) != 0);
                carry <= 'z;
                overflow <= 'z;
                flag <= 'z;
            end
    endcase

    r = res;

end

endmodule