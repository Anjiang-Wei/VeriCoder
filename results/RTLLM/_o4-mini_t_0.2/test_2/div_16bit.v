module div_16bit(
    input  wire [15:0] A,
    input  wire [ 7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

    // Internal registers
    reg  [15:0] a_reg;
    reg  [ 7:0] b_reg;
    reg  [15:0] q_reg;
    reg  [ 7:0] rem_reg;
    reg  [ 8:0] temp;
    integer     i;

    // Pipeline the inputs into registers (combinational)
    always @(A or B) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division: shift‑subtract restoring divider
    always @(A or B) begin
        q_reg   = 16'b0;
        rem_reg = 8'b0;
        // iterate from MSB down to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // shift left remainder and bring in next dividend bit
            temp = { rem_reg, a_reg[i] };
            // compare with divisor
            if (temp >= {1'b0, b_reg}) begin
                temp     = temp - {1'b0, b_reg};
                rem_reg  = temp[7:0];
                q_reg[i] = 1'b1;
            end else begin
                rem_reg  = temp[7:0];
                q_reg[i] = 1'b0;
            end
        end
    end

    // Output assignments
    assign result = q_reg;
    // zero‑extend the 8‑bit remainder to 16 bits
    assign odd    = { 8'b0, rem_reg };

endmodule