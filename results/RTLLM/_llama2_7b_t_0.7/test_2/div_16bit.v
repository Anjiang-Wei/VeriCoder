module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

  // Registers to hold the intermediate results
  reg [15:0] a_reg = 0;
  reg [15:0] b_reg = 0;

  always @(*) begin
    // Update the registers with the input values
    a_reg <= A;
    b_reg <= B;

    // Check if the dividend is greater than the divisor
    if (a_reg[15] > b_reg[7]) begin
      // Set the quotient to 1 and the remainder to 0
      result <= {1'b1, odd <= {1'b0}};
    end else begin
      // Set the quotient to 0 and the remainder to the difference between the dividend and divisor
      result <= {0'b1, odd <= a_reg - b_reg};
    end
  end

  always @(posedge A or posedge B) begin
    // Update the registers with the input values
    a_reg <= A;
    b_reg <= B;

    // Check if the dividend is greater than the divisor
    if (a_reg[15] > b_reg[7]) begin
      // Set the quotient to 1 and the remainder to 0
      result <= {1'b1, odd <= {1'b0}};
    end else begin
      // Set the quotient to 0 and the remainder to the difference between the dividend and divisor
      result <= {0'b1, odd <= a_reg - b_reg};
    end
  end

endmodule