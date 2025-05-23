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
    
    assign r[31:0] = case(aluc)
        ADD: a + b 
        ADDU: a + b 
        SUB: a - b 
        SUBU: a - b 
        AND: a & b 
        OR: a | b 
        XOR: a ^ b 
        NOR: ~(a | b)
        SLT: (a < b)? 1'b0: 1'b1  
        SLTU: (a <= b)? 1'b0: 1'b1   
        SLL: {a[31:24], a[23:0]} << 24 
        SRL: {a[31:24], a[23:0]} >> 24  
        SRA: {a[31:24], a[23:0]} / 24   
        SLLV: {a[31:24], a[23:0]} << 5  
        SRLV: {a[31:24], a[23:0]} >> 5   
        SRAV: {a[31:24], a[23:0]} / 5    
        LUI: {temp, 16'h0}   // 16'h0 is the upper half of a(31:16)
        default: 1'bz 
    endreg;
    
    assign zero = r[31]&1'b1;
    assign carry = r[31]&1'b1 || (r[31-1] == 1'b0 && (r[31:24] != 16'hffff));
    assign negative = {r[15], r[14:1]}.all()? 1'b0 : 1'b1; //16 bits of the result are all zero
    assign overflow = {r[7:0], r[31:24]}.all() && r[31].eq_1bit(1'b1); //25 bits of the result are all ones and 1 is in the 31st bit (max value)
    
    assign flag = {r[7:0], r[31:24]}.all()? 1'b0 : 1'b1;//25 bits of the result are all ones and 1 is in the 31st bit (max value)

endmodule