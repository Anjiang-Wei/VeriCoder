module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

reg [15:0] a_reg, b_reg;
reg [15:0] quotient;

always @(A or B) begin
    a_reg = A;
    b_reg = B;
end

always @(a_reg or b_reg) begin
    // Extract the higher bits of the dividend and match with divisor's bit width
    reg [7:0] temp_dividend = a_reg[15:8];
    
    // Compare these bits with the divisor
    if (temp_dividend > b_reg)
        quotient = 16'd1;
    else
        quotient = 16'd0;

    // Calculate remainder
    reg [7:0] temp_remainder = (a_reg[15:8] - b_reg);

    // Concatenate the remainder with the highest remaining 1-bit of the dividend
    a_reg = {temp_remainder, a_reg[7:0]};
    
    // Repeat process until all dividend bits are processed
    if (&a_reg)
        begin
            result <= quotient;
            odd <= a_reg;
        end
end

endmodule