module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

    // Declare internal registers
    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] quotient;
    reg [15:0] remainder;

    // Combinational logic for input registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational logic for division
    always @(*) begin
        quotient = 16'b0;
        remainder = 16'b0;
        
        // Process 16 bits of the dividend
        for (int i = 15; i >= 0; i--) begin
            // Extract higher bits of the dividend
            reg [7:0] dividend_bits;
            dividend_bits = a_reg[i+:8];
            
            // Compare and set quotient and remainder
            if (dividend_bits >= b_reg) begin
                quotient[i-8+:8] = 8'b1;
                remainder = dividend_bits - b_reg;
            end else begin
                quotient[i-8+:8] = 8'b0;
                remainder = dividend_bits;
            end
        end
        
        // Concatenate remainder and odd bit
        odd = {remainder[7:0], a_reg[15]};
    end

    // Assign output ports
    assign result = quotient;
    assign odd = odd;

endmodule