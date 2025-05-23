module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

  // Define two registers to hold the intermediate results
  reg [15:0] a_reg = 0;
  reg [15:0] b_reg = 0;

  // Always block triggered by any change in A or B
  always @* begin
    // Update the value of a_reg with the value of A
    if (A !== a_reg) a_reg <= A;

    // Update the value of b_reg with the value of B
    if (B !== b_reg) b_reg <= B;
  end

  // Always block triggered by any change in A and B
  always @* begin
    // Compute the quotient by comparing the highest bits of a_reg and b_reg
    reg [15:0] q = 0;
    if (a_reg[15] > b_reg[15]) q = 1;
    else if (a_reg[15] == b_reg[15]) q = 0;

    // Compute the remainder by subtracting the highest bits of a_reg from b_reg
    reg [15:0] r = a_reg - b_reg;

    // Store the result in result
    result <= q;

    // Store the remainder in odd
    odd <= r;
  end

endmodule