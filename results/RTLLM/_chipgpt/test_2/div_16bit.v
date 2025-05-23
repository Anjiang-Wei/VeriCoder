module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    reg [15:0] a_reg;
    reg [15:0] b_reg;
    wire [15:0] q;
    wire r;

    always @(A, B)
        a_reg = A;
        b_reg = B;

    always @(*) begin
        q[15:0] = 0;
        r[15:0] = 0;
        if (a_reg[0] > b_reg[0]) q[15:0] = 1;
        else q[15:0] = 0;
        r = a_reg - q;
        odd = a_reg[16];
    end

    always @(A, B) begin
        result[15:0] = 0;
        if (r == 0)
            begin
                casez(b_reg[7:0]) //case of divider of 2^8=256
                    3'd0: result[15:8] = A[15:8];
                    3'd1: result[15:16] = A[15:16];
                endcase
            end
        else begin
            result[15:0] = r + A;  //the remainder is always the least significant bit of dividend, and thus needs to be copied from it
    end

endmodule