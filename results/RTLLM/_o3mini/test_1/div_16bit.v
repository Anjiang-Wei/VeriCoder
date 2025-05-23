module div_16bit(
    input  wire [15:0] A,  // 16-bit dividend
    input  wire [7:0]  B,  // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient (computed bits in lower 9 bits, rest zero)
    output reg  [15:0] odd     // 16-bit remainder (8-bit remainder in lower portion)
    );

    // Internal registers to hold the input values.
    reg [15:0] a_reg;
    reg [7:0]  b_reg;
    
    // First always block: latch the input values into internal registers.
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: perform the combinational division
    // using a non-restoring long division algorithm.
    always @(*) begin
        integer i;  // loop variable
        // We will work with a remainder accumulator that is one bit wider than B.
        reg [8:0] rem;      // 9-bit remainder register
        reg [8:0] quotient; // 9-bit quotient register (we obtain one quotient bit per iteration)
        
        // Step 1: Extract the highest 8 bits of a_reg (the dividend)
        rem = a_reg[15:8];
        
        // Compare these 8 bits with the divisor (zero-extended to 9 bits):
        if (rem >= {1'b0, b_reg}) begin
            quotient[8] = 1'b1;
            rem = rem - {1'b0, b_reg};
        end
        else begin
            quotient[8] = 1'b0;
        end
        
        // Step 2: Process the remaining 8 bits of the dividend one at a time.
        // We start with the next highest bit: a_reg[7] then down to a_reg[0].
        for (i = 7; i >= 0; i = i - 1) begin
            // Concatenate the current remainder (dropping its MSB) with the next dividend bit.
            rem = {rem[7:0], a_reg[i]};
            // Compare with divisor.
            if (rem >= {1'b0, b_reg}) begin
                quotient[i] = 1'b1;
                rem = rem - {1'b0, b_reg};
            end
            else begin
                quotient[i] = 1'b0;
            end
        end

        // The quotient determined in this algorithm is 9 bits wide.
        // We pack these 9 bits into the lower portion of the 16-bit result output.
        // (The upper 7 bits of "result" are set to zero.)
        result = {7'b0, quotient};

        // The final remainder is contained in rem.
        // We output the lower 8 bits of rem in the 16-bit odd output.
        odd = {8'b0, rem[7:0]};
    end

endmodule