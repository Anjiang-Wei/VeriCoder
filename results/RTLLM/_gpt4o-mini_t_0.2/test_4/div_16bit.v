module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );

    reg [15:0] a_reg; // Register to hold dividend
    reg [7:0] b_reg;  // Register to hold divisor
    reg [15:0] remainder; // Remainder
    integer i; // Loop variable

    always @* begin
        // Initialize the registers
        a_reg = A;
        b_reg = B;
        remainder = 0;
        result = 0;

        // Perform division
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift the remainder left to make room for the next bit of A
            remainder = {remainder[14:0], a_reg[i]};
            
            // Compare with the divisor
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg; // Subtract the divisor
                result[i] = 1; // Set the quotient bit
            end else begin
                result[i] = 0; // Set the quotient bit
            end
        end
        
        // Output the final remainder
        odd = remainder;
    end
endmodule