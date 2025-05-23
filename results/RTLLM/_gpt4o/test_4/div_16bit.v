module div_16bit(
    input wire [15:0] A,      // 16-bit dividend
    input wire [7:0] B,       // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
    );

    // Internal variables
    reg [15:0] temp_dividend; // Register to hold intermediate dividend
    reg [7:0]  temp_divisor;  // Intermediate divisor
    reg [7:0]  current_bits;  // Current subset of dividend bits
    reg [15:0] temp_result;   // To track quotient
    integer i;                // Loop variable

    // Combinational logic block
    always @(*) begin
        temp_dividend = A;      // Initialize dividend
        temp_divisor = B;       // Initialize divisor
        temp_result = 16'b0;    // Initialize result to 0
        odd = 16'b0;            // Initialize remainder to 0

        // Loop through all 16 bits of the dividend
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift in the next bit from the dividend to the current_bits
            current_bits = {odd[6:0], temp_dividend[15]}; // Combine remainder and current dividend bit
            temp_dividend = temp_dividend << 1;           // Left shift the dividend
            
            // Compare the current_bits with the divisor
            if (current_bits >= temp_divisor) begin
                temp_result = (temp_result << 1) | 1;     // Set the quotient bit to 1
                current_bits = current_bits - temp_divisor; // Subtract divisor to get remainder
            end else begin
                temp_result = temp_result << 1;           // Set the quotient bit to 0
            end

            // Update the odd (remainder) with current_bits
            odd = {odd[14:0], temp_dividend[15]};
            odd[7:0] = current_bits;
        end

        // Assign final results
        result = temp_result;
    end

endmodule