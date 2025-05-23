module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result = 16'b0;
    odd = 16'b0;
    
    for (int i = 15; i >= 0; i = i - 1) begin
        if (a_reg[i:i-7+1] >= b_reg) begin
            result[i] = 1'b1;
            a_reg[i:i-7+1] = a_reg[i:i-7+1] - b_reg;
        end
    end
    
    odd = a_reg[15:1];
end

endmodule