module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

  // Initialize registers for dividend and divisor
  reg [15:0] a_reg = A;
  reg [7:0] b_reg = B;

  // Always block for updating registers
  always @(*) begin
    // Update a_reg with A
    if (A !== a_reg) begin
      a_reg <= A;
    end

    // Update b_reg with B
    if (B !== b_reg) begin
      b_reg <= B;
    end
  end

  // Division operation
  always @(posedge A or posedge B) begin
    // Calculate quotient and remainder
    reg [15:0] q = a_reg / b_reg;
    reg [15:0] r = a_reg - (q * b_reg);

    // Update result with quotient
    result <= q;

    // Set odd to 1 if remainder is non-zero
    odd <= r !== 0;
  end

endmodule