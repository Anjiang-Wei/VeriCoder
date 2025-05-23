module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output wire [31:0] r,
    output wire        zero,
    output wire        carry,
    output wire        negative,
    output wire        overflow,
    output wire        flag
    );

    // operation codes
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

    // internal 33‐bit results for carry/borrow detection
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};

    reg  [31:0] r_reg;
    reg         carry_reg;
    reg         overflow_reg;

    // main ALU
    always @(*) begin
        // defaults
        r_reg        = 32'b0;
        carry_reg    = 1'b0;
        overflow_reg = 1'b0;
        case(aluc)
            ADD: begin
                r_reg        = add_res[31:0];
                carry_reg    = add_res[32];
                // signed overflow: signs of a and b same, != sign of result
                overflow_reg = (~a[31] & ~b[31] &  r_reg[31]) |
                               ( a[31] &  b[31] & ~r_reg[31]);
            end
            ADDU: begin
                r_reg        = add_res[31:0];
                carry_reg    = add_res[32];
                overflow_reg = 1'b0;
            end
            SUB: begin
                r_reg        = sub_res[31:0];
                carry_reg    = sub_res[32];  // 1 if no borrow
                // signed overflow for a - b
                overflow_reg = ( a[31] & ~b[31] & ~r_reg[31]) |
                               (~a[31] &  b[31] &  r_reg[31]);
            end
            SUBU: begin
                r_reg        = sub_res[31:0];
                carry_reg    = sub_res[32];
                overflow_reg = 1'b0;
            end
            AND_: begin
                r_reg        = a & b;
            end
            OR_: begin
                r_reg        = a | b;
            end
            XOR_: begin
                r_reg        = a ^ b;
            end
            NOR_: begin
                r_reg        = ~(a | b);
            end
            SLT: begin
                // signed comparison
                r_reg        = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            end
            SLTU: begin
                // unsigned comparison
                r_reg        = (a < b) ? 32'd1 : 32'd0;
            end
            SLL: begin
                r_reg        = b << a[4:0];
            end
            SRL: begin
                r_reg        = b >> a[4:0];
            end
            SRA: begin
                r_reg        = $signed(b) >>> a[4:0];
            end
            SLLV: begin
                r_reg        = b << a[4:0];
            end
            SRLV: begin
                r_reg        = b >> a[4:0];
            end
            SRAV: begin
                r_reg        = $signed(b) >>> a[4:0];
            end
            LUI: begin
                r_reg        = {b[15:0], 16'b0};
            end
            default: begin
                r_reg        = 32'b0;
                carry_reg    = 1'b0;
                overflow_reg = 1'b0;
            end
        endcase
    end

    // outputs
    assign r        = r_reg;
    assign zero     = (r_reg == 32'b0);
    assign carry    = carry_reg;
    assign negative = r_reg[31];
    assign overflow = overflow_reg;
    // flag is meaningful only for SLT and SLTU
    assign flag     = (aluc == SLT)  ? r_reg[0] :
                      (aluc == SLTU) ? r_reg[0] :
                                       1'b0;

endmodule