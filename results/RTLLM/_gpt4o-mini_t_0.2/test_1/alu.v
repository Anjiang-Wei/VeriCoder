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

    always @(*) begin
        // Initialize output flags
        r = 32'b0;
        zero = 1'b0;
        carry = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                {carry, r} = a + b; // Full adder to capture carry
                overflow = (a[31] == b[31]) && (r[31] != a[31]); // Overflow detection
            end
            ADDU: begin
                {carry, r} = a + b; // Unsigned addition doesn't check overflow
            end
            SUB: begin
                {carry, r} = a - b;
                overflow = (a[31] != b[31]) && (r[31] != a[31]); // Overflow detection in signed subtraction
            end
            SUBU: begin
                {carry, r} = a - b; // Unsigned subtraction
            end
            AND: r = a & b;
            OR: r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                r = (a < b) ? 32'b1 : 32'b0; // Set if less than
                flag = 1'b1; // Set the flag for SLT
            end
            SLTU: begin
                r = ($unsigned(a) < $unsigned(b)) ? 32'b1 : 32'b0; // Set if less than unsigned
                flag = 1'b1; // Set the flag for SLTU
            end
            SLL: r = b << a[4:0]; // Logical shift left
            SRL: r = b >> a[4:0]; // Logical shift right
            SRA: r = $signed(b) >>> a[4:0]; // Arithmetic shift right
            SLLV: r = b << a[4:0]; // Logical shift left variable
            SRLV: r = b >> a[4:0]; // Logical shift right variable
            SRAV: r = $signed(b) >>> a[4:0]; // Arithmetic shift right variable
            LUI: r = {b[15:0], 16'b0}; // Load upper immediate
            default: r = 32'bz; // Undefined operation (high impedance)
        endcase
        
        // Set zero and negative flags
        zero = (r == 32'b0);
        negative = r[31];
    end
endmodule