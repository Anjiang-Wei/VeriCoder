module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );

    wire [15:0] a_reg;
    wire [7:0] b_reg;

    always @(A or B) begin
        a_reg <= A;
        b_reg <= B;
    end

    always @(a_reg or b_reg) begin
        result = 16'b0;
        odd = 16'b0;
        for (integer i = 0; i < 16; i = i + 1) begin
            if (a_reg[15:8] >= b_reg) begin
                result[i] = 1'b1;
                a_reg = a_reg[15:8] - b_reg;
            end else begin
                result[i] = 1'b0;
                a_reg = {1'b0, a_reg[15:1]};
            end
            odd = {odd[14:0], a_reg[7]};
        end
    end
endmodule