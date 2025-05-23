module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
    );

    // ALU operation codes
    parameter ADD   = 6'b100000;
    parameter ADDU  = 6'b100001;
    parameter SUB   = 6'b100010;
    parameter SUBU  = 6'b100011;
    parameter AND_  = 6'b100100;
    parameter OR_   = 6'b100101;
    parameter XOR_  = 6'b100110;
    parameter NOR_  = 6'b100111;
    parameter SLT   = 6'b101010;
    parameter SLTU  = 6'b101011;
    parameter SLL   = 6'b000000;
    parameter SRL   = 6'b000010;
    parameter SRA   = 6'b000011;
    parameter SLLV  = 6'b000100;
    parameter SRLV  = 6'b000110;
    parameter SRAV  = 6'b000111;
    parameter LUI   = 6'b001111;

    // internal result and flags
    reg  [31:0] res;
    reg         cflag;      // carry out
    reg         oflag;      // overflow

    // signed versions for signed operations
    wire signed [31:0] sa = a;
    wire signed [31:0] sb = b;

    always @(*) begin
        // default assignments
        res   = 32'b0;
        cflag = 1'b0;
        oflag = 1'b0;

        case(aluc)
            // signed ADD
            ADD: begin
                {cflag, res} = {1'b0, a} + {1'b0, b};
                // overflow if signs of inputs are same and sign of result differs
                oflag = (a[31] & b[31] & ~res[31]) |
                        (~a[31] & ~b[31] &  res[31]);
            end

            // unsigned ADD
            ADDU: begin
                {cflag, res} = {1'b0, a} + {1'b0, b};
                oflag = 1'b0;
            end

            // signed SUB
            SUB: begin
                {cflag, res} = {1'b0, a} - {1'b0, b};
                // overflow if signs of operands differ and sign of result differs from sign of a
                oflag = (a[31] & ~b[31] & ~res[31]) |
                        (~a[31] & b[31] &  res[31]);
            end

            // unsigned SUB
            SUBU: begin
                {cflag, res} = {1'b0, a} - {1'b0, b};
                oflag = 1'b0;
            end

            // bitwise AND
            AND_: begin
                res   = a & b;
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // bitwise OR
            OR_: begin
                res   = a | b;
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // bitwise XOR
            XOR_: begin
                res   = a ^ b;
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // bitwise NOR
            NOR_: begin
                res   = ~(a | b);
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // set-on-less-than (signed)
            SLT: begin
                res   = (sa < sb) ? 32'd1 : 32'd0;
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // set-on-less-than (unsigned)
            SLTU: begin
                res   = (a < b) ? 32'd1 : 32'd0;
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // shift left logical (by immediate a[4:0])
            SLL: begin
                res   = b << a[4:0];
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // shift right logical (by immediate a[4:0])
            SRL: begin
                res   = b >> a[4:0];
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // shift right arithmetic (by immediate a[4:0])
            SRA: begin
                res   = $signed(b) >>> a[4:0];
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // shift left logical variable (by a[4:0])
            SLLV: begin
                res   = b << a[4:0];
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // shift right logical variable (by a[4:0])
            SRLV: begin
                res   = b >> a[4:0];
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // shift right arithmetic variable (by a[4:0])
            SRAV: begin
                res   = $signed(b) >>> a[4:0];
                cflag = 1'b0;
                oflag = 1'b0;
            end

            // load upper immediate
            LUI: begin
                res   = {b[15:0], 16'b0};
                cflag = 1'b0;
                oflag = 1'b0;
            end

            default: begin
                res   = 32'b0;
                cflag = 1'b0;
                oflag = 1'b0;
            end
        endcase
    end

    // outputs
    assign r        = res;
    assign zero     = (res == 32'b0);
    assign carry    = cflag;
    assign negative = res[31];
    assign overflow = oflag;
    // flag = result of SLT/SLTU, otherwise 0
    assign flag     = ((aluc == SLT) || (aluc == SLTU)) ? res[0] : 1'b0;

endmodule