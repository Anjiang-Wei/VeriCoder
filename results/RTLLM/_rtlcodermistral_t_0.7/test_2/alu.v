```verilog
    reg [31:0] res;
    wire [31:0] a_signed, b_signed;
    wire zero, carry, negative, overflow;
    wire [4:0] shift_amount;
    wire [1:0] shift_type;
    wire [31:0] result;

    assign a_signed = $signed(a);
    assign b_signed = $signed(b);

    assign zero = (res == 0) ? 1 : 0;
    assign carry = (aluc == ADDU || aluc == SUB || aluc == SLLV || aluc == SRLV || aluc == SRAV || aluc == LUI) ? res[31] : 0;
    assign negative = (res[31] == 1) ? 1 : 0;
    assign overflow = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? (a_signed[31] != b_signed[31] && res[31] == a_signed[31]) : 0;

    always @(*) begin
        case(aluc)
            ADD: begin
                res = a_signed + b_signed;
            end
            ADDU: begin
                res = a_signed + b_signed;
                res[31] = (res[31] == 1) ? 1 : 0;
            end
            SUB: begin
                res = a_signed - b_signed;
            end
            SUBU: begin
                res = a_signed - b_signed;
                res[31] = (res[31] == 1) ? 1 : 0;
            end
            AND: begin
                res = a & b;
            end
            OR: begin
                res = a | b;
            end
            XOR: begin
                res = a ^ b;
            end
            NOR: begin
                res = ~(a | b);
            end
            SLT: begin
                res = (a_signed < b_signed) ? 1 : 0;
                flag = 1;
            end
            SLTU: begin
                res = (a < b) ? 1 : 0;
                flag = 1;
            end
            SLL: begin
                shift_amount = a[4:0];
                shift_type = 2'b00;
                res = a << shift_amount;
            end
            SRL: begin
                shift_amount = a[4:0];
                shift_type = 2'b01;
                res = a >> shift_amount;
            end
            SRA: begin
                shift_amount = a[4:0];
                shift_type = 2'b10;
                res = $signed({a[31], a[31:shift_amount]}) >> shift_amount;
            end
            SLLV: begin
                shift_amount = b[4:0];
                shift_type = 2'b00;
                res = a << shift_amount;
            end
            SRLV: begin
                shift_amount = b[4:0];
                shift_type = 2'b01;
                res = a >> shift_amount;
            end
            SRAV: begin
                shift_amount = b[4:0];
                shift_type = 2'b10;
                res = $signed({a[31], a[31:shift_amount]}) >> shift_amount;
            end
            LUI: begin
                res = {16'b0, a[31:16]};
            end
            default: begin
                res = 32'bz;
            end
        endcase
    end

    assign result = (flag == 1) ? res : 32'bz;
    assign r = result;
endmodule