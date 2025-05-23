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

    // Parameter definitions
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

    // Input validation
    always @* begin
        // Ignore invalid input values
        if (|a) || (|b) || (!aluc[4:0]) begin
            r <= 32'h0;
            zero <= 1'b0;
            carry <= 1'b0;
            negative <= 1'b0;
            overflow <= 1'b0;
            flag <= 1'b0;
            return;
        end else begin
            // Handle valid input values
            case (aluc) matches
                ADD: begin
                    r <= a + b;
                    zero <= (a == 0 && b == 0);
                    carry <= (a < b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                SUB: begin
                    r <= a - b;
                    zero <= (a == 0 && b == 0);
                    carry <= (a > b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                SUBU: begin
                    r <= a - b;
                    zero <= (a == 0 && b == 0);
                    carry <= (a > b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                AND: begin
                    r <= a & b;
                    zero <= (a == 0 || b == 0);
                    carry <= (a != b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                OR: begin
                    r <= a | b;
                    zero <= (a == 0 || b == 0);
                    carry <= (a != b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                XOR: begin
                    r <= a ^ b;
                    zero <= (a == 0 || b == 0);
                    carry <= (a != b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                NOR: begin
                    r <= ~(a | b);
                    zero <= (a == 0 || b == 0);
                    carry <= (a != b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                SLT: begin
                    r <= a < b;
                    zero <= (a == b);
                    carry <= (a > b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                SLTU: begin
                    r <= a < b;
                    zero <= (a == b);
                    carry <= (a > b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
                LUI: begin
                    r <= a - b;
                    zero <= (a == 0 || b == 0);
                    carry <= (a != b);
                    negative <= (r < 0);
                    overflow <= (r > 32'hFFFF_FFFF);
                    flag <= (slt(a, b) || sltu(a, b));
                end
            endcase
        end