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
    
    wire [31:0] res[31:0]; //shifted with 16 bits or 0 for others
    assign zero = ~r && (a == b);
    assign carry = r&{1'b1, {32{1'b0}}}[aluc-1] || !zero;
    assign negative = r&{{1'b0, {32{1'b1}}}[aluc-1] || !zero && a!=0;
    assign overflow = r&{1'b1, {32{1'b0}}}[aluc-1] && !zero; //overflow is based on 64-bit operation
    assign flag = (aluc == SLT || aluc == SLTU) ? zero : ~zero;
    
    always @(*) begin
        case(aluc)
            ADD: res[31:0] = a + b;
            SUB: res[31:0] = a - b;
            ADDU: res[31:0] = a + b;
            SUBU: res[31:0] = a - b;
            AND: res[31:0] = a&b;
            OR: res[31:0] = a|b;
            XOR: res[31:0] = a ^ b;
            NOR: res[31:0] = ~(a|b); //negate the or and then perform an xor with b
            SLT: res[31:0] = a < b ? {1'b1,{32{1'b0}}}[b-a] : {1'b0,{32{1'b1}}} ;  //0 if a is equal to b otherwise 1
            SLTU: res[31:0] = a > b ? {1'b1,{32{1'b0}}}[a-b] : {1'b0,{32{1'b1}}} ;
            SLL: res[31:0] = {32{1'b0}}&~(a<<b);
            SRL: res[31:0] = a>>b; //left shift of 16 bits or 0 if others
            SRA: res[31:0] = a>>(b-1);
            SLLV: res[31:0] = a<<(b-1);
            SRLV: res[31:0] = a>>>(b-1);
            SRAV: res[31:0] = a>>(b-1)%a; //the modulo of the shifter is 32 bits, which would result in a value between 0 and 31. We only need one bit so we simply use (b-1)/32
            LUI: res[31:0] = a;//1'b0 if the shift amount is 0 or else the content of that vector. Note this is not zero extension but instead the upper half will be moved to the lower half
        endcase
    end
endmodule