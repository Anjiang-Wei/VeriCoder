module div_16bit(
    input  wire [15:0] A,      // 16‐bit dividend
    input  wire [7:0]  B,      // 8–bit divisor
    output wire [15:0] result, // 16–bit quotient (the lower 8–bits contain the computed quotient)
    output wire [15:0] odd     // 16–bit remainder (the lower 8–bits contain the remainder)
    );

    // internal registers to hold the input values
    reg [15:0] a_reg;
    reg [7:0]  b_reg;
    
    // internal registers for outputs
    reg [15:0] result_reg;
    reg [15:0] odd_reg;
    
    // 
    // First always block: Latch inputs into internal registers
    // 
    always @(*) begin
      // update internal copies when A or B change
      a_reg = A;
      b_reg = B;
    end

    // 
    // Second always block: Compute division via long–division algorithm.
    // The procedure is:
    // 1. Extract the top 8–bits of the dividend (same as B’s width).
    // 2. For each of the remaining 8 bits:
    //    a. Concatenate the current remainder (8 bits) with the next bit of A.
    //    b. Compare with b_reg.
    //       – If the value is >= b_reg, subtract it and set the corresponding quotient bit to 1.
    //       – Else, set that quotient bit to 0.
    // 3. Output the quotient (as a 16–bit value with the lower 8–bits used) 
    //    and the remainder (extended to 16–bits).
    // 
    always @(*) begin
      // Default assignments in case B==0.
      // (Division by zero is handled here simply by returning zeros.)
      if (b_reg == 0) begin
         result_reg = 16'd0;
         odd_reg    = 16'd0;
      end
      else begin
         // We use an 9–bit temporary remainder.
         // It starts with the top 8 bits of the dividend.
         reg [8:0] rem;
         // 8–bit quotient (each bit is computed by one iteration)
         reg [7:0] quot;
         integer     i;
         
         rem = a_reg[15:8];
         // Iterate over the remaining bits in a_reg; the following loop
         // concatenates the next (lower) bit onto the current remainder.
         // Since we are processing 8 bits, we use an index from 7 downto 0.
         for (i = 7; i >= 0; i = i - 1) begin
            // Concatenate the lower 8 bits of rem with the next bit from a_reg.
            rem = {rem[7:0], a_reg[i]};
            // If the new rem is greater than or equal to the divisor, subtract it
            // and mark quotient bit i as 1. Otherwise leave rem unchanged.
            if (rem >= b_reg) begin
               rem    = rem - b_reg;
               quot[i] = 1'b1;
            end
            else begin
               quot[i] = 1'b0;
            end
         end
         // Build the 16–bit outputs.
         // We assign the 8–bit quotient into the lower 8 bits of a 16–bit result.
         result_reg = {8'd0, quot};
         // The remainder is 8–bits; extend it to 16–bits.
         odd_reg = {8'd0, rem[7:0]};
      end
    end

    // Continuous assignment of internal registers to the module outputs.
    assign result = result_reg;
    assign odd    = odd_reg;
    
endmodule