module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
    // Registers to hold intermediate values
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;
    integer i;

    always @* begin
        // Initialize the temporary values
        dividend = A;
        divisor = B;
        quotient = 0;
        remainder = 0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift the remainder left and add the next bit from the dividend
            remainder = {remainder[14:0], dividend[i]};
            // Perform the comparison
            if (remainder >= {8'b0, divisor}) begin
                remainder = remainder - {8'b0, divisor}; // Subtract divisor
                quotient[i] = 1'b1; // Set the i-th bit of the quotient to 1
            end else begin
                quotient[i] = 1'b0; // Set the i-th bit of the quotient to 0
            end
        end

        // Assign results to output ports
        result = quotient; // The final quotient is ready
        odd = remainder;   // The final remainder is ready
    end
endmodule