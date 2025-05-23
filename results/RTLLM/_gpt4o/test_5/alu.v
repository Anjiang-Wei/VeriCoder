module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
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

    reg signed [31:0] signed_a, signed_b;
    reg [32:0] res_ext; // Used for carry detection (e.g., 33-bit result for addition)

    // Assign inputs to signed versions of a and b for operations like SLT and subtraction.
    assign signed_a = a;
    assign signed_b = b;

    // Assign zero flag
    assign zero = (r == 32'b0);

    // Assign negative flag (MSB of result)
    assign negative = r[31];

    always @(*) begin
        // Default values for control signals
        carry = 0;
        overflow = 0;
        flag = 0;
        res_ext = 0;

        case (aluc)
            ADD: begin
                res_ext = {a[31], a} + {b[31], b}; // 33-bit addition to track carry and overflow
                r = res_ext[31:0];                // Result is lower 32-bits
                carry = res_ext[32];              // Carry is the 33rd bit
                // Overflow occurs when signs of a and b are the same, but differ from the result
                overflow = (a[31] == b[31]) && (a[31] != r[31]);
            end
            ADDU: begin
                res_ext = a + b;                  // Unsigned addition (ignores overflow)
                r = res_ext[31:0];
                carry = res_ext[32];
            end
            SUB: begin
                res_ext = {a[31], a} - {b[31], b}; // 33-bit subtraction
                r = res_ext[31:0];
                carry = res_ext[32];
                // Overflow occurs when signs of a and b differ, and the result differs from a
                overflow = (a[31] != b[31]) && (r[31] != a[31]);
            end
            SUBU: begin
                res_ext = a - b;                  // Unsigned subtraction
                r = res_ext[31:0];
                carry = res_ext[32];              // Carry can be directly taken
            end
            AND: begin
                r = a & b;                        // Bitwise AND
            end
            OR: begin
                r = a | b;                        // Bitwise OR
            end
            XOR: begin
                r = a ^ b;                        // Bitwise XOR
            end
            NOR: begin
                r = ~(a | b);                     // Bitwise NOR
            end
            SLT: begin
                r = (signed_a < signed_b) ? 32'b1 : 32'b0; // Set r to 1 if a < b (signed comparison)
                flag = (r != 0);                  // Update flag for SLT
            end
            SLTU: begin
                r = (a < b) ? 32'b1 : 32'b0;      // Set r to 1 if a < b (unsigned comparison)
                flag = (r != 0);                  // Update flag for SLTU
            end
            SLL: begin
                r = b << a[4:0];                  // Logical left shift, shift amount is from a[4:0]
            end
            SRL: begin
                r = b >> a[4:0];                  // Logical right shift
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];        // Arithmetic right shift
            end
            SLLV: begin
                r = b << a[4:0];                  // Logical left shift by variable amount
            end
            SRLV: begin
                r = b >> a[4:0];                  // Logical right shift by variable amount
            end
            SRAV: begin
                r = $signed(b) >>> a[4:0];        // Arithmetic right shift by variable amount
            end
            LUI: begin
                r = {b[15:0], 16'b0};             // Load upper immediate (b upper 16 bits concatenated with 16 zeros)
            end
            default: begin
                r = 32'bz;                        // High-impedance for unsupported operations
                carry = 1'bz;
                overflow = 1'bz;
                flag = 1'bz;
            end
        endcase
    end
endmodule