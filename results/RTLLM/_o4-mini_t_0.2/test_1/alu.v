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

    // ALU control codes
    parameter ADD   = 6'b100000;
    parameter ADDU  = 6'b100001;
    parameter SUB   = 6'b100010;
    parameter SUBU  = 6'b100011;
    parameter AND   = 6'b100100;
    parameter OR    = 6'b100101;
    parameter XOR   = 6'b100110;
    parameter NOR   = 6'b100111;
    parameter SLT   = 6'b101010;
    parameter SLTU  = 6'b101011;
    parameter SLL   = 6'b000000;
    parameter SRL   = 6'b000010;
    parameter SRA   = 6'b000011;
    parameter SLLV  = 6'b000100;
    parameter SRLV  = 6'b000110;
    parameter SRAV  = 6'b000111;
    parameter LUI   = 6'b001111;

    // Extended results for carry/borrow detection
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};

    // 32‐bit sums
    wire [31:0] sum  = add_res[31:0];
    wire [31:0] diff = sub_res[31:0];

    // Carry out of ADD, borrow out of SUB
    wire        add_carry   = add_res[32];
    wire        sub_borrow  = sub_res[32];  // '1' means a<b in unsigned subtraction

    // Signed overflow detection
    wire        add_overflow = (~a[31] & ~b[31] & sum[31]) |
                              ( a[31] &  b[31] & ~sum[31]);
    wire        sub_overflow = (~a[31] &  b[31] & diff[31]) |
                              ( a[31] & ~b[31] & ~diff[31]);

    // Main result register
    reg [31:0] res;

    always @(*) begin
        case(aluc)
            ADD, ADDU:  res = sum;
            SUB, SUBU:  res = diff;
            AND:        res = a & b;
            OR:         res = a | b;
            XOR:        res = a ^ b;
            NOR:        res = ~(a | b);
            SLT:        res = {31'b0, ($signed(a) < $signed(b))};
            SLTU:       res = {31'b0, (a < b)};
            SLL:        res = b << a[4:0];
            SRL:        res = b >> a[4:0];
            SRA:        res = $signed(b) >>> a[4:0];
            SLLV:       res = b << a[4:0];
            SRLV:       res = b >> a[4:0];
            SRAV:       res = $signed(b) >>> a[4:0];
            LUI:        res = {a[31:16], 16'b0};
            default:    res = {32{1'bz}};
        endcase
    end

    // Output assignments
    assign r        = res;
    assign zero     = (res == 32'b0);
    assign negative = res[31];

    // Carry: for ADD/ADDU use add_carry,
    //        for SUB/SUBU use inverted borrow bit,
    //        otherwise zero
    assign carry = (aluc == ADD  || aluc == ADDU) ? add_carry :
                   (aluc == SUB  || aluc == SUBU) ? ~sub_borrow :
                   1'b0;

    // Overflow: only for signed ADD and signed SUB
    assign overflow = (aluc == ADD) ? add_overflow :
                      (aluc == SUB) ? sub_overflow :
                      1'b0;

    // Flag: only driven (to 0/1) for SLT and SLTU,
    //       otherwise hi-Z
    assign flag = (aluc == SLT)  ? ($signed(a) < $signed(b)) :
                  (aluc == SLTU) ? (a < b) :
                  1'bz;

endmodule