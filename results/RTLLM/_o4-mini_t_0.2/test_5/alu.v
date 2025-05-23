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

    // ALU function codes
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

    // Signed versions of inputs
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    // Wide add/sub to capture carry/borrow
    wire [32:0] sum  = {1'b0, a} + {1'b0, b};
    wire [32:0] diff = {1'b0, a} - {1'b0, b};

    // Overflow detection
    // For addition: if a and b same sign, result different sign
    wire ov_add = (~a[31] & ~b[31] & sum[31])
                | ( a[31] &  b[31] & ~sum[31]);
    // For subtraction: if a and b different sign, result sign same as b
    wire ov_sub = (~a[31] &  b[31] & diff[31])
                | ( a[31] & ~b[31] & ~diff[31]);

    // Internal result register
    reg [31:0] res;
    always @(*) begin
        case(aluc)
            ADD:  res = sum[31:0];
            ADDU: res = sum[31:0];
            SUB:  res = diff[31:0];
            SUBU: res = diff[31:0];
            AND_: res = a & b;
            OR_:  res = a | b;
            XOR_: res = a ^ b;
            NOR_: res = ~(a | b);
            SLT:  res = (a_s < b_s)  ? 32'd1 : 32'd0;
            SLTU: res = (a     < b)  ? 32'd1 : 32'd0;
            SLL:  res = b << a[4:0];
            SRL:  res = b >> a[4:0];
            SRA:  res = b_s >>> a[4:0];
            SLLV: res = b << a[4:0];
            SRLV: res = b >> a[4:0];
            SRAV: res = b_s >>> a[4:0];
            LUI:  res = {a[31:16], 16'b0};
            default: res = {32{1'bz}};
        endcase
    end

    // Output assignments
    assign r        = res;
    assign zero     = (res == 32'b0);
    assign negative = res[31];
    assign carry    = (aluc == ADD  || aluc == ADDU) ? sum[32] :
                      (aluc == SUB  || aluc == SUBU) ? diff[32] :
                      1'b0;
    assign overflow = (aluc == ADD) ? ov_add :
                      (aluc == SUB) ? ov_sub :
                      1'b0;
    assign flag     = (aluc == SLT)  ? (a_s < b_s) :
                      (aluc == SLTU) ? (a    < b)   :
                      1'b0;

endmodule