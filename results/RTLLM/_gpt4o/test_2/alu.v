module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
    );
    
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    reg carry_out;  // Temporary carry-out signal
    reg overflow_flag;  // Temporary overflow signal
    wire signed [31:0] a_signed = a;  // Treat 'a' as signed
    wire signed [31:0] b_signed = b;  // Treat 'b' as signed

    always @(*) begin
        carry_out = 0;  // Default carry is 0
        overflow_flag = 0;  // Default overflow is 0
        flag = 1'bz;  // Default flag is high-impedance
        case (aluc)
            ADD: begin  // Signed addition
                {carry_out, r} = a + b;  // Perform addition with carry-out
                overflow_flag = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);  // Overflow check
            end
            ADDU: begin  // Unsigned addition
                {carry_out, r} = a + b;
            end
            SUB: begin  // Signed subtraction
                {carry_out, r} = a - b;
                overflow_flag = (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]);  // Overflow check
            end
            SUBU: begin  // Unsigned subtraction
                {carry_out, r} = a - b;
            end
            AND: begin  // Bitwise AND
                r = a & b;
            end
            OR: begin  // Bitwise OR
                r = a | b;
            end
            XOR: begin  // Bitwise XOR
                r = a ^ b;
            end
            NOR: begin  // Bitwise NOR
                r = ~(a | b);
            end
            SLT: begin  // Set less than (signed)
                r = (a_signed < b_signed) ? 1 : 0;
                flag = (a_signed < b_signed) ? 1 : 0;
            end
            SLTU: begin  // Set less than unsigned
                r = (a < b) ? 1 : 0;
                flag = (a < b) ? 1 : 0;
            end
            SLL: begin  // Logical shift left
                r = b << a[4:0];
            end
            SRL: begin  // Logical shift right
                r = b >> a[4:0];
            end
            SRA: begin  // Arithmetic shift right
                r = $signed(b) >>> a[4:0];
            end
            SLLV: begin  // Logical shift left variable
                r = b << a[4:0];
            end
            SRLV: begin  // Logical shift right variable
                r = b >> a[4:0];
            end
            SRAV: begin  // Arithmetic shift right variable
                r = $signed(b) >>> a[4:0];
            end
            LUI: begin  // Load upper immediate
                r = {b[15:0], 16'b0};
            end
            default: begin  // If no valid opcode is matched
                r = 32'bz;  // High-impedance
            end
        endcase
    end

    assign zero = (r == 0);  // Result is zero if all bits in 'r' are 0
    assign carry = carry_out;  // Carry-out signal
    assign negative = r[31];  // Negative if MSB of 'r' is 1
    assign overflow = overflow_flag;  // Overflow signal
    
endmodule