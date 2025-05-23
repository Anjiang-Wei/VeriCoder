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

    wire [32:0] add_result; // To capture carry out from addition
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    
    // Calculate the result based on the opcode
    always @(*) begin
        case (aluc)
            ADD: begin
                add_result = signed_a + signed_b;
                r = add_result[31:0];
                flag = 1'b0;
            end

            ADDU: begin
                add_result = a + b;
                r = add_result[31:0];
                flag = 1'b0;
            end
            
            SUB: begin
                add_result = signed_a - signed_b;
                r = add_result[31:0];
                flag = 1'b0;
            end
            
            SUBU: begin
                add_result = a - b;
                r = add_result[31:0];
                flag = 1'b0;
            end

            AND: begin
                r = a & b;
                flag = 1'b0;
            end
            
            OR: begin
                r = a | b;
                flag = 1'b0;
            end
            
            XOR: begin
                r = a ^ b;
                flag = 1'b0;
            end
            
            NOR: begin
                r = ~(a | b);
                flag = 1'b0;
            end
            
            SLT: begin
                r = (signed_a < signed_b) ? 32'b1 : 32'b0;
                flag = 1'b1;
            end
            
            SLTU: begin
                r = (a < b) ? 32'b1 : 32'b0;
                flag = 1'b1;
            end
            
            SLL: begin
                r = b << a[4:0];
                flag = 1'b0;
            end
            
            SRL: begin
                r = b >> a[4:0];
                flag = 1'b0;
            end
            
            SRA: begin
                r = signed_b >>> a[4:0];
                flag = 1'b0;
            end
            
            SLLV: begin
                r = b << a[4:0];
                flag = 1'b0;
            end
            
            SRLV: begin
                r = b >> a[4:0];
                flag = 1'b0;
            end
            
            SRAV: begin
                r = signed_b >>> a[4:0];
                flag = 1'b0;
            end
            
            LUI: begin
                r = {b[15:0], 16'b0};
                flag = 1'b0;
            end
            
            default: begin
                r = 32'bz; // High impedance for unsupported operations
                flag = 1'b0;
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign carry = add_result[32]; // Use to check if there's a carry from addition
    assign negative = r[31]; // Negative if the highest bit is 1
    assign overflow = (aluc == ADD || aluc == SUB) && 
                      (add_result[31] != add_result[32]); // Check for arithmetic overflow

endmodule