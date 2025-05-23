module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output          zero,
    output reg      carry,
    output          negative,
    output reg      overflow,
    output reg      flag
    );

    // ALU control codes
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

    // Combinational ALU
    // We extend to 33 bits for carry/borrow detection
    wire [32:0] sum33  = {1'b0, a} + {1'b0, b};
    wire [32:0] diff33 = {1'b0, a} - {1'b0, b};

    always @(*) begin
        // default values
        r        = 32'b0;
        carry    = 1'b0;
        overflow = 1'b0;
        flag     = 1'b0;

        case (aluc)
            // signed add
            ADD: begin
                {carry, r} = sum33;
                // overflow if a and b same sign, result sign differs
                overflow = (~a[31] & ~b[31] &  r[31]) |
                           ( a[31] &  b[31] & ~r[31]);
            end

            // unsigned add
            ADDU: begin
                {carry, r} = sum33;
                overflow   = 1'b0;
            end

            // signed subtract
            SUB: begin
                {carry, r} = diff33;
                // overflow if a and b differ in sign and result sign differs from a
                overflow = ( a[31] & ~b[31] & ~r[31]) |
                           (~a[31] &  b[31] &  r[31]);
            end

            // unsigned subtract
            SUBU: begin
                {carry, r} = diff33;
                overflow   = 1'b0;
            end

            // bitwise logical
            AND_:    r = a & b;
            OR_:     r = a | b;
            XOR_:    r = a ^ b;
            NOR_:    r = ~(a | b);

            // set-on-less-than
            SLT: begin
                // signed comparison
                flag = ($signed(a) < $signed(b));
                r    = {31'b0, flag};
            end

            // set-on-less-than unsigned
            SLTU: begin
                flag = (a < b);
                r    = {31'b0, flag};
            end

            // immediate shift by a[4:0]
            SLL:  r = b << a[4:0];
            SRL:  r = b >> a[4:0];
            SRA:  r = $signed(b) >>> a[4:0];

            // variable shift by a[4:0]
            SLLV: r = b << a[4:0];
            SRLV: r = b >> a[4:0];
            SRAV: r = $signed(b) >>> a[4:0];

            // load upper immediate: take upper 16 bits of a, zero‐extend lower
            LUI:  r = {a[15:0], 16'b0};

            default: begin
                // unsupported opcodes yield zero
                r        = 32'b0;
                carry    = 1'b0;
                overflow = 1'b0;
                flag     = 1'b0;
            end
        endcase
    end

    // status flags
    assign zero     = (r == 32'b0);
    assign negative = r[31];

endmodule