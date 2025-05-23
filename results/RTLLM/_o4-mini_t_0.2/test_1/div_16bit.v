module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    // registers to hold inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // registers for internal quotient and remainder
    reg [15:0] q_reg;
    reg [7:0]  r_reg;

    // temporary 9‑bit to hold shifted remainder + next dividend bit
    reg [8:0] tmp;
    integer   i;

    // latch inputs into regs (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // combinational long division (restoring) algorithm
    always @(*) begin
        // initialize
        q_reg = 16'h0000;
        r_reg = 8'h00;

        // iterate over all 16 bits of the dividend
        for (i = 15; i >= 0; i = i - 1) begin
            // shift remainder left by 1 and bring in the next bit of a_reg
            tmp   = { r_reg, a_reg[i] };

            // compare tmp with divisor
            if (tmp >= b_reg) begin
                q_reg[i] = 1'b1;
                r_reg    = tmp - b_reg;
            end else begin
                q_reg[i] = 1'b0;
                r_reg    = tmp;
            end
        end
    end

    // output assignments
    assign result = q_reg;
    // zero‑extend the 8‑bit remainder to 16 bits
    assign odd    = { 8'h00, r_reg };

endmodule