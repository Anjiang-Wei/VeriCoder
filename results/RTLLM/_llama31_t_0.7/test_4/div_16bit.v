module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(A or B) begin
    a_reg <= A;
    b_reg <= B;
end

always @(a_reg or b_reg) begin
    // Extract higher bits of dividend, matching bit width of divisor
    reg [7:0] dividend_bits;
    dividend_bits = a_reg[15:8];
    
    // Compare extracted bits with divisor
    if (dividend_bits > b_reg) begin
        result <= 16'b1;
        odd <= a_reg;
    end else begin
        result <= 16'b0;
        odd <= a_reg - b_reg;
    end
    
    // Repeat process for remaining bits of dividend
    if (result == 16'h0000 && a_reg != 16'h0000) begin
        a_reg = {a_reg[7:0], a_reg[15:8]};
        result = 16'b0;
        odd = 16'b0;
    end
end

// Assign remainder to odd output
assign odd = (result == 16'hffff) ? a_reg : odd;

endmodule