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

    reg signed [31:0] a_signed, b_signed; // Signed versions of inputs
    reg signed [32:0] res;               // Wider result to detect overflow/carry

    // Assign negative, zero flags (combinational logic)
    assign zero = (r == 32'b0)? 1'b1 : 1'b0;
    assign negative = r[31]; // Negative if MSB is set (sign flag in 2's complement)

    always @(*) begin
        // Default values
        res = 0;
        carry = 0;
        overflow = 0;
        flag = 0;
        a_signed = a;
        b_signed = b;

        // ALU operation based on opcode
        case (aluc)
            ADD: begin
                res = a_signed + b_signed;
                r = res[31:0];
                carry = res[32]; // Carry bit from MSB overflow
                overflow = (a_signed[31] == b_signed[31]) && (r[31] != a_signed[31]); // Overflow detection
            end
            ADDU: begin
                res = a + b; // Unsigned addition
                r = res[31:0];
                carry = res[32]; // Carry bit from MSB overflow
            end
            SUB: begin
                res = a_signed - b_signed;
                r = res[31:0];
                carry = res[32]; // Borrow in case of unsigned subtraction
                overflow = (a_signed[31] != b_signed[31]) && (r[31] != a_signed[31]); // Overflow detection
            end
            SUBU: begin
                res = a - b; // Unsigned subtraction
                r = res[31:0];
                carry = res[32]; // Borrow out (when a < b for unsigned)
            end
            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0; // Set less than (signed)
                r = {31'd0, flag};
            end
            SLTU: begin
                flag = (a < b) ? 1'b1 : 1'b0; // Set less than (unsigned)
                r = {31'd0, flag};
            end
            SLL: r = b << a[4:0];            // Logical shift left
            SRL: r = b >> a[4:0];            // Logical shift right
            SRA: r = $signed(b) >>> a[4:0];  // Arithmetic shift right (preserve sign)
            SLLV: r = b << a[4:0];           // Variable shift left
            SRLV: r = b >> a[4:0];           // Variable shift right
            SRAV: r = $signed(b) >>> a[4:0]; // Arithmetic variable shift right
            LUI: r = {b[15:0], 16'b0};       // Load upper immediate
            default: r = 32'bz;              // High-impedance for invalid opcode
        endcase
    end

endmodule