module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );

    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] temp_remainder;
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        // Initialize registers
        dividend = A;
        divisor = B;
        temp_remainder = 0;
        quotient = 0;
        
        for (i = 15; i >= 8; i = i - 1) begin
            // Bring down the next bit from the dividend
            temp_remainder = (temp_remainder << 1) | (dividend[i] ? 1'b1 : 1'b0);
            
            // Compare temp_remainder with divisor
            if (temp_remainder >= divisor) begin
                temp_remainder = temp_remainder - divisor;
                quotient[i] = 1'b1; // Set the corresponding bit of the quotient
            end else begin
                quotient[i] = 1'b0; // Set to 0 if less
            end
        end
        
        // Process the last 8 bits
        for (i = 7; i >= 0; i = i - 1) begin
            // Bring down the next bit
            temp_remainder = (temp_remainder << 1) | (dividend[i] ? 1'b1 : 1'b0);
            
            // Compare temp_remainder with divisor
            if (temp_remainder >= divisor) begin
                temp_remainder = temp_remainder - divisor;
                quotient[i] = 1'b1; // Set the corresponding bit of the quotient
            end else begin
                quotient[i] = 1'b0; // Set to 0 if less
            end
        end
        
        // Assign the final results
        result = quotient;
        odd = temp_remainder;
    end
endmodule