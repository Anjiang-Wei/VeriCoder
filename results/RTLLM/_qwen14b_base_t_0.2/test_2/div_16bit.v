module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );
    
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [7:0] remainder;
    
    always @(*) begin
        dividend = A;
        divisor = B;
        quotient = 16'b0;
        remainder = 8'b0;
        
        for (int i = 8; i >= 0; i = i - 1) begin
            // Shift the remainder left by 1 and add the next bit of the dividend
            remainder = {remainder[6:0], dividend[15]};
            dividend = dividend << 1;
            
            // If the remainder is greater than or equal to the divisor
            if (remainder >= divisor) begin
                // Subtract the divisor from the remainder
                remainder = remainder - divisor;
                // Set the corresponding quotient bit to 1
                quotient[i] = 1'b1;
            end else begin
                // Set the corresponding quotient bit to 0
                quotient[i] = 1'b0;
            end
        end
        
        // Assign the final quotient and remainder
        result = quotient;
        odd = remainder;
    end
    
endmodule