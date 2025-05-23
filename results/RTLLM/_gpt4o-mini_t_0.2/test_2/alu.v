module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
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
    
    wire [31:0] add_result, sub_result, and_result, or_result, xor_result, nor_result;
    wire add_carry, sub_carry, add_overflow, sub_overflow;
    
    // Carry out and overflow detection
    assign {add_carry, add_result} = a + b;
    assign {sub_carry, sub_result} = a - b;
    assign add_overflow = (a[31] == b[31]) && (add_result[31] != a[31]);
    assign sub_overflow = (a[31] != b[31]) && (sub_result[31] != a[31]);
    
    assign and_result = a & b;
    assign or_result = a | b;
    assign xor_result = a ^ b;
    assign nor_result = ~(a | b);
    
    always @(*) begin
        case (aluc)
            ADD: r = add_result;
            ADDU: r = a + b; // No carry/overflow checks for unsigned add
            SUB: r = sub_result;
            SUBU: r = a - b; // No carry/overflow checks for unsigned sub
            AND: r = and_result;
            OR: r = or_result;
            XOR: r = xor_result;
            NOR: r = nor_result;
            SLT: r = (a < b) ? 32'b1 : 32'b0; 
            SLTU: r = ($unsigned(a) < $unsigned(b)) ? 32'b1 : 32'b0;
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = $signed(b) >> a[4:0];
            SLLV: r = b << a[4:0];
            SRLV: r = b >> a[4:0];
            SRAV: r = $signed(b) >> a[4:0];
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'bz; // High impedance for undefined operations
        endcase
    end
    
    assign zero = (r == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU) ? add_carry :
                   (aluc == SUB || aluc == SUBU) ? sub_carry : 1'b0;
    assign negative = r[31];
    assign overflow = (aluc == ADD || aluc == SUB) && (aluc == ADD ? add_overflow : sub_overflow);
    assign flag = (aluc == SLT || aluc == SLTU) ? ((aluc == SLT) ? (a < b) : ($unsigned(a) < $unsigned(b))) : 1'b0;

endmodule