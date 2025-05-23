module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
    );

    // Opcode definitions
    parameter ADD   = 6'b100000;
    parameter ADDU  = 6'b100001;
    parameter SUB   = 6'b100010;
    parameter SUBU  = 6'b100011;
    parameter AND   = 6'b100100;
    parameter OR    = 6'b100101;
    parameter XOR   = 6'b100110;
    parameter NOR   = 6'b100111;
    parameter SLT   = 6'b101010;
    parameter SLTU  = 6'b101011;
    parameter SLL   = 6'b000000;
    parameter SRL   = 6'b000010;
    parameter SRA   = 6'b000011;
    parameter SLLV  = 6'b000100;
    parameter SRLV  = 6'b000110;
    parameter SRAV  = 6'b000111;
    parameter LUI   = 6'b001111;

    // Internal registers to capture the ALU operation result and flags.
    reg [31:0] res;
    reg        carry_reg;
    reg        overflow_reg;

    // Combinational logic for performing the ALU operation
    // Note: For ADD and SUB the carry and overflow are computed as follows:
    //   - Carry: use the 33rd bit from full-width addition/subtraction.
    //   - Overflow: for addition, if the operands have the same sign but the result
    //               has a different sign; for subtraction, if sign(a) != sign(b) and
    //               sign(result) != sign(a).
    always @(*) begin
        // Default assignments
        res = 32'b0;
        carry_reg = 1'b0;
        overflow_reg = 1'b0;
        case(aluc)
            ADD: begin
                // Unsigned addition to catch carry out
                {carry_reg, res} = a + b;
                // Overflow for signed addition:
                // if a[31] and b[31] are the same but different from res[31]
                overflow_reg = (~(a[31] ^ b[31]) & (a[31] ^ res[31]));
            end
            ADDU: begin
                {carry_reg, res} = a + b;
                overflow_reg = 1'b0;
            end
            SUB: begin
                {carry_reg, res} = a - b;
                // Overflow: if a and b have different signs and result sign differs from a
                overflow_reg = ((a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]));
            end
            SUBU: begin
                {carry_reg, res} = a - b;
                overflow_reg = 1'b0;
            end
            AND: begin
                res = a & b;
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            OR: begin
                res = a | b;
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            XOR: begin
                res = a ^ b;
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            NOR: begin
                res = ~(a | b);
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            SLT: begin
                // Signed compare: if a < b then result is 1, else 0.
                res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            SLTU: begin
                // Unsigned compare: if a < b then result is 1, else 0.
                res = (a < b) ? 32'd1 : 32'd0;
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            SLL: begin
                // Shift Left Logical: shift b left by amount specified in a[4:0]
                res = b << a[4:0];
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            SRL: begin
                // Shift Right Logical
                res = b >> a[4:0];
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            SRA: begin
                // Shift Right Arithmetic (preserve sign)
                res = ($signed(b)) >>> a[4:0];
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            SLLV: begin
                // Variable shift left: shift b left by amount in a[4:0]
                res = b << a[4:0];
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            SRLV: begin
                // Variable shift right logical
                res = b >> a[4:0];
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            SRAV: begin
                // Variable shift right arithmetic
                res = ($signed(b)) >>> a[4:0];
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            LUI: begin
                // Load Upper Immediate: Concatenate the lower 16 bits of a with 16 zeros.
                res = {a[15:0], 16'b0};
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
            end
            default: begin
                // Default to high-impedance if no operation matches.
                res = 32'bz;
                carry_reg = 1'bz;
                overflow_reg = 1'bz;
            end
        endcase
    end

    // Output assignments.
    // r: returns the ALU result.
    assign r = res;
    // zero: assert 1 if the result is zero.
    assign zero = (res == 32'b0) ? 1'b1 : 1'b0;
    // negative: check the MSB of the result.
    assign negative = res[31];
    // carry: result from addition/subtraction operations.
    assign carry = carry_reg;
    // overflow: based on signed arithmetic operations.
    assign overflow = overflow_reg;
    // flag: set to 1 for SLT and SLTU operations, else high impedance.
    assign flag = ((aluc == SLT) || (aluc == SLTU)) ? 1'b1 : 1'bz;

endmodule