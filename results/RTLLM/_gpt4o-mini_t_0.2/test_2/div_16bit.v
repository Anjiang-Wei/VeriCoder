module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] remainder;
    integer i;
    
    always @* begin
        // Initialize registers
        a_reg = A;
        b_reg = B;
        result = 16'b0;                // Initialize quotient to zero
        remainder = 16'b0;             // Initialize remainder to zero
        
        // Start division process
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit and bring down the next bit of the dividend
            remainder = {remainder[14:0], a_reg[i]};
            
            // Compare current remainder with divisor
            if (remainder >= {8'b0, b_reg}) begin
                remainder = remainder - {8'b0, b_reg}; // Update remainder
                result[i] = 1;                        // Set quotient bit to 1
            end
            else begin
                result[i] = 0;                        // Set quotient bit to 0
            end
        end
        
        // Final value of remainder
        odd = remainder;  // The final remainder is assigned to output odd
    end
    
endmodule