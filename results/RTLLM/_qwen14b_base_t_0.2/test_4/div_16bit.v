module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );
    
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [3:0] bit_position;

    always @(A or B) begin
        dividend = A;
        divisor = B;
        quotient = 16'b0;
        remainder = 16'b0;
        bit_position = 0;
    end

    always @(posedge dividend or posedge divisor) begin
        if (bit_position < 16) begin
            // Extract the current 8-bit segment of the dividend
            reg [7:0] current_segment;
            if (bit_position < 8) begin
                current_segment = dividend[7:0];
            end else begin
                current_segment = dividend[15:8];
            end

            // Compare the current segment with the divisor
            if (current_segment >= divisor) begin
                // If the current segment is greater than or equal to the divisor
                remainder = remainder << 1;
                remainder[7:0] = current_segment - divisor;
                quotient[bit_position] = 1;
            end else begin
                // If the current segment is less than the divisor
                remainder = remainder << 1;
                remainder[7:0] = current_segment;
                quotient[bit_position] = 0;
            end

            // Move to the next bit position
            bit_position = bit_position + 1;
        end else begin
            // All bits processed, assign final values
            result = quotient;
            odd = remainder;
        end
    end

endmodule