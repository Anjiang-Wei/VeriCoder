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

    // Intermediate signals
    reg [32:0] add_res;  // Extra bit for carry/overflow detection

    always @(*) begin
        case (aluc)
            ADD: begin
                add_res = a + b; // 33 bits for overflow
                r = add_res[31:0];
            end
            ADDU: begin
                r = a + b; 
            end
            SUB: begin
                add_res = a - b; // 33 bits for overflow
                r = add_res[31:0];
            end
            SUBU: begin
                r = a - b; 
            end
            AND: begin
                r = a & b; 
            end
            OR: begin
                r = a | b; 
            end
            XOR: begin
                r = a ^ b; 
            end
            NOR: begin
                r = ~(a | b); 
            end
            SLT: begin
                r = (a < b) ? 32'b1 : 32'b0; 
            end
            SLTU: begin
                r = ($unsigned(a) < $unsigned(b)) ? 32'b1 : 32'b0; 
            end
            SLL: begin
                r = b << a[4:0];
            end
            SRL: begin
                r = b >> a[4:0];
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
            end
            SLLV: begin
                r = b << a[4:0];
            end
            SRLV: begin
                r = b >> a[4:0];
            end
            SRAV: begin
                r = $signed(b) >>> a[4:0];
            end
            LUI: begin
                r = {a[15:0], 16'b0}; 
            end
            default: begin
                r = 32'bz; // Undefined operation
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign carry = (aluc == ADD || aluc == SUB) ? add_res[32] : 1'b0; // Carry only for addition and subtraction
    assign negative = r[31]; // Check if the sign bit is set
    assign overflow = ((aluc == ADD || aluc == SUB) && (add_res[32] ^ add_res[31])); // Overflow check
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule