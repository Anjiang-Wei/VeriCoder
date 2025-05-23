module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    reg [15:0] a_reg;
    reg [15:0] b_reg;
    reg [15:0] q_reg;
    reg [15:0] r_reg;

    always @(A or B) begin
        a_reg <= A;
        b_reg <= B;
    end

    always @(a_reg or b_reg) begin
        q_reg = 16'b0;
        r_reg = 16'b0;

        for (integer i = 0; i < 16; i = i + 1) begin
            if (a_reg[15:8] >= b_reg) begin
                q_reg[15:8] = 16'b1;
                r_reg[15:8] = a_reg[15:8] - b_reg;
            end else begin
                q_reg[15:8] = 16'b0;
                r_reg[15:8] = a_reg[15:8];
            end

            a_reg = {r_reg[7:0], 1'b0};
        end

        result = q_reg;
        odd = r_reg;
    end

endmodule