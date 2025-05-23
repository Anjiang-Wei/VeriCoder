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
    
    // Define the ALU operation codes
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

    // Internal signals for additional calculations
    reg signed [31:0] signed_a, signed_b;       // Signed versions of a and b
    reg [32:0] temp_res;                        // Temporary result to check carry
    reg signed [32:0] signed_temp_res;          // Temporary signed result for overflow checks
    
    always @(*) begin
        // Initialize outputs to default values
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        zero = 1'b0;
        negative = 1'b0;
        flag = 1'bz;

        signed_a = a;
        signed_b = b;

        case (aluc)
            // Addition
            ADD: begin
                signed_temp_res = signed_a + signed_b;
                temp_res = {1'b0, a} + {1'b0, b};
                r = signed_temp_res[31:0];
                carry = temp_res[32];                          // Carry out
                overflow = (signed_temp_res[31] != signed_temp_res[30]); // Overflow
            end
            
            // Unsigned Addition
            ADDU: begin
                temp_res = {1'b0, a} + {1'b0, b};
                r = temp_res[31:0];
                carry = temp_res[32];
            end
            
            // Subtraction
            SUB: begin
                signed_temp_res = signed_a - signed_b;
                temp_res = {1'b0, a} - {1'b0, b};
                r = signed_temp_res[31:0];
                carry = temp_res[32];                          // Borrow out
                overflow = (signed_temp_res[31] != signed_temp_res[30]); // Overflow
            end
            
            // Unsigned Subtraction
            SUBU: begin
                temp_res = {1'b0, a} - {1'b0, b};
                r = temp_res[31:0];
                carry = temp_res[32];
            end
            
            // AND Operation
            AND: begin
                r = a & b;
            end
            
            // OR Operation
            OR: begin
                r = a | b;
            end
            
            // XOR Operation
            XOR: begin
                r = a ^ b;
            end
            
            // NOR Operation
            NOR: begin
                r = ~(a | b);
            end

            // Set Less Than (signed)
            SLT: begin
                r = (signed_a < signed_b) ? 32'b1 : 32'b0;
                flag = (signed_a < signed_b) ? 1'b1 : 1'b0;
            end

            // Set Less Than Unsigned
            SLTU: begin
                r = (a < b) ? 32'b1 : 32'b0;
                flag = (a < b) ? 1'b1 : 1'b0;
            end

            // Logical left shift
            SLL: begin
                r = b << a[4:0];
            end
            
            // Logical right shift
            SRL: begin
                r = b >> a[4:0];
            end
            
            // Arithmetic right shift
            SRA: begin
                r = $signed(b) >>> a[4:0];
            end
            
            // Variable logical left shift
            SLLV: begin
                r = b << a[4:0];
            end
            
            // Variable logical right shift
            SRLV: begin
                r = b >> a[4:0];
            end
            
            // Variable arithmetic right shift
            SRAV: begin
                r = $signed(b) >>> a[4:0];
            end
            
            // Load upper immediate
            LUI: begin
                r = {b[15:0], 16'b0};
            end

            // Default case
            default: begin
                r = 32'bz; // High-impedance state
            end
        endcase

        // Set flags
        zero = (r == 32'b0) ? 1'b1 : 1'b0;        // Zero flag
        negative = r[31];                         // Negative flag (sign bit)
    end
endmodule