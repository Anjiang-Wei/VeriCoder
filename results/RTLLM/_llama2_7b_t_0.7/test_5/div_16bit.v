module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

  // Registers to store the intermediate results
  reg [15:0] a_reg = A;
  reg [15:0] b_reg = B;

  // Always block for updating registers
  always @(*) begin
    case (A)
      // Update a_reg with A
      A: a_reg <= A;
      // Update b_reg with B
      B: b_reg <= B;
    endcase
  end

  // Always block for calculating quotient and remainder
  always @(*) begin
    case (a_reg)
      // If dividend is greater than divisor, set result to 1 and odd to 0
      A > B: result <= 1; odd <= 0;
      // If dividend is less than or equal to divisor, set result to 0 and odd to 1
      else: result <= 0; odd <= 1;
    endcase
    // Shift the remainder by one bit
    odd[1] <= odd[0];
  end

  // Output result and odd
  result <= a_reg;
  odd <= b_reg;

endmodule