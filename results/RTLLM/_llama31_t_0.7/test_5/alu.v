module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
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

reg [31:0] res;

always @(a, b, aluc)
begin
    case(aluc)
        ADD: begin
            res <= a + b;
            zero <= (res == 32'd0);
            carry <= ((a[31]^b[31])^res[31]);
            negative <= res[31];
            overflow <= (a[31] ^ b[31] ^ res[31]);
            flag <= 'z;
        end
        ADDU: begin
            res <= a + b;
            zero <= (res == 32'd0);
            carry <= ((a[31]^b[31])^res[31]);
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        SUB: begin
            res <= a - b;
            zero <= (res == 32'd0);
            carry <= ((~(a[31] ^ b[31]) & ~(b[31]))^res[31]);
            negative <= res[31];
            overflow <= (~a[31] & b[31] & ~res[31]) | (a[31] & ~b[31] & res[31]);
            flag <= 'z;
        end
        SUBU: begin
            res <= a - b;
            zero <= (res == 32'd0);
            carry <= ((~(a[31] ^ b[31]) & ~(b[31]))^res[31]);
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        AND: begin
            res <= a & b;
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        OR: begin
            res <= a | b;
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        XOR: begin
            res <= a ^ b;
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        NOR: begin
            res <= ~((a | b) & (a | b));
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        SLT: begin
            if (~signed(a) > signed(b))
                res <= 32'd1;
            else
                res <= 32'd0;
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 1'b1;
        end
        SLTU: begin
            if (~a > ~b)
                res <= 32'd1;
            else
                res <= 32'd0;
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 1'b1;
        end
        SLL: begin
            res <= {32'd0, a << aluc[4:0]};
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        SRL: begin
            res <= {a >> aluc[4:0}, 32'd0};
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        SRA: begin
            res <= {{aluc[4:0]{1}}, a >> aluc[4:0]};
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        SLLV: begin
            if (~a > 0)
                res <= {32'd0, a << b};
            else
                res <= a;
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        SRLV: begin
            if (~a > 0)
                res <= {a >> b, 32'd0};
            else
                res <= a;
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        SRAV: begin
            if (~a > 0)
                res <= {{b{1}}, a >> b};
            else
                res <= a;
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        LUI: begin
            res <= {{aluc[15:8]{4}}, {aluc[7:0]{3}{2}}};
            zero <= (res == 32'd0);
            carry <= 'bz;
            negative <= res[31];
            overflow <= 'bz;
            flag <= 'z;
        end
        default:
            begin
                res <= a + b;
                zero <= (res == 32'd0);
                carry <= ((a[31]^b[31])^res[31]);
                negative <= res[31];
                overflow <= 'bz;
                flag <= 'z;
            end
    endcase

end

assign r = res;

endmodule