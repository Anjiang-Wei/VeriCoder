module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

wire [15:0] temp_result;
wire [15:0] temp_odd;

always @(A or B) begin
    a_reg = A;
    b_reg = B;
end

always @(a_reg or b_reg) begin
    if (b_reg != 0) begin
        // Extract the higher bits of the dividend matching the bit width of the divisor
        wire [7:0] high_bits = a_reg[15:8];

        // Compare these bits with the divisor
        if (high_bits > b_reg) begin
            temp_result = {16{1'b1}};
            temp_odd = a_reg;
        end else begin
            temp_result = {16{1'b0}};
            temp_odd = high_bits - b_reg;
        end

        // Concatenate the remainder with the highest remaining 1-bit of the dividend
        if (temp_odd > b_reg) begin
            result <= temp_result;
            odd <= {16{1'b1}} | a_reg[7:0];
        end else begin
            result <= temp_result;
            odd <= temp_odd & ~a_reg[7:8];
        end

    end else begin
        // Handle divide by zero error
        result = 0;
        odd = a_reg;
    end
end

endmodule