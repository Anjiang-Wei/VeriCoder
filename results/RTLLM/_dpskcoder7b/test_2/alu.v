reg [31:0] res;
    wire [31:0] slt;

    assign {overflow, res} = alu_operations(a, b, aluc);
    assign slt = a < b ? 32'b1 : 32'b0;

    assign zero = (res == 32'b0);
    assign negative = res[31];
    assign carry = (~a[31] & b[31] & res[31]) | (a[31] & ~b[31] & ~res[31]);
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;

    assign r = res;

    function [31:0] alu_operations;
        input [31:0] a;
        input [31:0] b;
        input [5:0] aluc;
        begin
            case(aluc)
                ADD: alu_operations = a + b;
                ADDU: alu_operations = a + b;
                SUB: alu_operations = a - b;
                SUBU: alu_operations = a - b;
                AND: alu_operations = a & b;
                OR: alu_operations = a | b;
                XOR: alu_operations = a ^ b;
                NOR: alu_operations = ~(a | b);
                SLT: alu_operations = a < b ? 32'b1 : 32'b0;
                SLTU: alu_operations = a < b ? 32'b1 : 32'b0;
                SLL: alu_operations = a << b[4:0];
                SRL: alu_operations = a >> b[4:0];
                SRA: alu_operations = $signed(a) >>> b[4:0];
                SLLV: alu_operations = a << b;
                SRLV: alu_operations = a >> b;
                SRAV: alu_operations = $signed(a) >>> b;
                LUI: alu_operations = {16'b0, b};
                default: alu_operations = 32'bz;
            endcase
        end
    endfunction
endmodule