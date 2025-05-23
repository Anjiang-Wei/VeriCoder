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

wire signed [31:0] res_sign_a, res_sign_b;
wire signed [31:0] res;
wire sign_bit;

always @ (*)
begin
    // Assign operands to signed wires and result (res) to lower 32 bits of register (res[31:0])
    res_sign_a = $signed(a);
    res_sign_b = $signed(b);

    case (aluc)
        ADD:
            begin
                {carry, overflow} = res_sign_a + res_sign_b;
                sign_bit = res_sign_a[31];
                r = res_sign_a + res_sign_b;
            end

        ADDU:
            begin
                {carry, overflow} = res_sign_a + res_sign_b;
                r = res_sign_a + res_sign_b;
                sign_bit = 0; // unsigned result, no sign bit
            end

        SUB:
            begin
                {carry, overflow} = res_sign_a - res_sign_b;
                sign_bit = res_sign_a[31];
                r = res_sign_a - res_sign_b;
            end

        SUBU:
            begin
                {carry, overflow} = res_sign_a - res_sign_b;
                r = res_sign_a - res_sign_b;
                sign_bit = 0; // unsigned result, no sign bit
            end

        AND:
            begin
                r = res_sign_a & res_sign_b;
                carry = 'b0;
                {sign_bit, overflow} = {1'b0, 'b0};
            end

        OR:
            begin
                r = res_sign_a | res_sign_b;
                carry = 'b0;
                {sign_bit, overflow} = {1'b0, 'b0};
            end

        XOR:
            begin
                r = res_sign_a ^ res_sign_b;
                carry = 'b0;
                {sign_bit, overflow} = {1'b0, 'b0};
            end

        NOR:
            begin
                r = ~(res_sign_a | res_sign_b);
                carry = 'b0;
                {sign_bit, overflow} = {1'b0, 'b0};
            end

        SLT:
            begin
                flag = 1; // set for SLT operation
                if (res_sign_a < res_sign_b) r = 32'd1;
                else r = 32'd0;
                carry = 'b0;
                {sign_bit, overflow} = {1'b0, 'b0};
            end

        SLTU:
            begin
                flag = 1; // set for SLTU operation
                if (res_sign_a < res_sign_b) r = 32'd1;
                else r = 32'd0;
                carry = 'b0;
                {sign_bit, overflow} = {1'b0, 'b0};
            end

        SLL:
            begin
                r = $signed({{res_sign_a[31:25], res_sign_a[24]} << res_sign_a[4:0]});
                sign_bit = 0; // unsigned result, no sign bit
                carry = 'b0;
            end

        SRL:
            begin
                r = {res_sign_a[31:25] >> (res_sign_a[4:0])};
                sign_bit = 0; // unsigned result, no sign bit
                carry = 'b0;
            end

        SRA:
            begin
                r = $signed({{res_sign_a[31:25], res_sign_a[24]} >> res_sign_a[4:0]});
                sign_bit = 0; // unsigned result, no sign bit
                carry = 'b0;
            end

        SLLV:
            begin
                r = {res_sign_a << res_sign_b};
                sign_bit = 0; // unsigned result, no sign bit
                carry = 'b0;
            end

        SRLV:
            begin
                r = {res_sign_a[31:25] >> (res_sign_b)};
                sign_bit = 0; // unsigned result, no sign bit
                carry = 'b0;
            end

        SRAV:
            begin
                r = $signed({{res_sign_a[31:25], res_sign_a[24]} >> (res_sign_b)});
                sign_bit = 0; // unsigned result, no sign bit
                carry = 'b0;
            end

        LUI:
            begin
                r = {{32'd1 << 16} | {res_sign_a[15:0]}};
                carry = 'b0;
                {sign_bit, overflow} = {1'b0, 'b0};
            end

        default:
            begin
                r = 32'dx; // unknown opcode, return X
                carry = 'b0;
                sign_bit = 0; // unsigned result, no sign bit
            end
    endcase

    // Assign output values
    negative = ~sign_bit & (res != 0);

end

always @ (*)
begin
    zero = ((res == 32'd0) ? 1 : 0);
end

endmodule