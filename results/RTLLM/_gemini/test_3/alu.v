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

    wire [31:0] res;
    wire [32:0] res_ext;
    assign r = res[31:0];

    assign zero = (res == 32'b0) ? 1'b1 : 1'b0;
    assign negative = res[31];
    assign flag = (aluc == SLT || aluc == SLTU) ? res[31] : 1'bz;

    assign carry = res_ext[32];
    assign overflow = (res_ext[31] ^ res_ext[32]) & (a[31] ^ b[31]);

    // Signed operands
    wire [31:0] signed_a = a;
    wire [31:0] signed_b = b;

    // Unsigned operands
    wire [31:0] unsigned_a = a;
    wire [31:0] unsigned_b = b;

    // Result register
    reg [32:0] res;

    always @(*) begin
        case (aluc)
            ADD: res = signed_a + signed_b;
            ADDU: res = unsigned_a + unsigned_b;
            SUB: res = signed_a - signed_b;
            SUBU: res = unsigned_a - unsigned_b;
            AND: res = signed_a & signed_b;
            OR: res = signed_a | signed_b;
            XOR: res = signed_a ^ signed_b;
            NOR: res = ~(signed_a | signed_b);
            SLT: res = (signed_a < signed_b) ? 32'b1 : 32'b0;
            SLTU: res = (unsigned_a < unsigned_b) ? 32'b1 : 32'b0;
            SLL: res = signed_a << a[4:0];
            SRL: res = signed_a >> a[4:0];
            SRA: res = signed_a >>> a[4:0];
            SLLV: res = signed_a << b[4:0];
            SRLV: res = signed_a >> b[4:0];
            SRAV: res = signed_a >>> b[4:0];
            LUI: res = {a[15:0], 16'b0};
            default: res = 32'bz;
        endcase
    endcase
endmodule