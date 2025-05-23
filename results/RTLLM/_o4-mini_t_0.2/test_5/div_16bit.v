module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

  // Internal registers to hold inputs
  reg [15:0] a_reg;
  reg [7:0]  b_reg;

  // Intermediate quotient and remainder
  reg [15:0] quotient;
  reg [8:0]  remainder;   // one extra bit for the shift before subtract

  // Registers to drive the outputs
  reg [15:0] result_reg;
  reg [15:0] odd_reg;

  integer i;

  //--------------------------------------------------------
  // always block #1: latch inputs into internal registers
  //--------------------------------------------------------
  always @(*) begin
    a_reg = A;
    b_reg = B;
  end

  //--------------------------------------------------------
  // always block #2: combinational restoring division
  //--------------------------------------------------------
  always @(*) begin
    // initialize
    remainder = 9'd0;
    quotient  = 16'd0;

    // perform 16-step shift-subtract division
    for (i = 15; i >= 0; i = i - 1) begin
      // shift left remainder and bring in next MSB of dividend
      remainder = { remainder[7:0], a_reg[i] };

      // compare and subtract if possible
      if (remainder >= {1'b0, b_reg}) begin
        remainder        = remainder - {1'b0, b_reg};
        quotient[i]      = 1'b1;
      end
      else begin
        quotient[i]      = 1'b0;
      end
    end

    // drive output registers
    result_reg = quotient;
    // final remainder fits in 8 bits; zero‑extend to 16 bits
    odd_reg    = {8'd0, remainder[7:0]};
  end

  // continuous assignments to outputs
  assign result = result_reg;
  assign odd    = odd_reg;

endmodule