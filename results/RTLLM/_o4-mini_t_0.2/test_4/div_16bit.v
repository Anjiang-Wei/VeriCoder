module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output wire [15:0] result,
    output wire [15:0] odd
);

  // -------------------------------------------------------
  // 1) Input registers (combinationally transparent)
  // -------------------------------------------------------
  reg [15:0] a_reg;
  reg  [7:0] b_reg;

  always @(*) begin
    a_reg = A;
    b_reg = B;
  end

  // -------------------------------------------------------
  // 2) Combinational restoring division
  //    - rem_ext is a 9‑bit “extended remainder” register
  //    - We shift in one bit of a_reg per iteration,
  //      compare to the 9‑bit divisor ({1'b0, b_reg}),
  //      subtract if >=, and record the quotient bit.
  // -------------------------------------------------------
  reg [15:0] q_reg;
  reg  [8:0] rem_ext;
  integer     i;

  always @(*) begin
    rem_ext = 9'b0;
    q_reg   = 16'b0;
    // unrolled 16‑step loop, MSB first
    for (i = 15; i >= 0; i = i - 1) begin
      // shift left rem_ext and bring in next dividend bit
      rem_ext = { rem_ext[7:0], a_reg[i] };
      // compare against zero‑extended divisor
      if (rem_ext >= {1'b0, b_reg}) begin
        rem_ext   = rem_ext - {1'b0, b_reg};
        q_reg[i]  = 1'b1;
      end
      else begin
        q_reg[i]  = 1'b0;
        // rem_ext stays as is (restoring division)
      end
    end
  end

  // -------------------------------------------------------
  // 3) Outputs
  //    - result = quotient
  //    - odd    = zero‑extend the 8‑bit remainder to 16 bits
  // -------------------------------------------------------
  assign result = q_reg;
  assign odd    = { 8'b0, rem_ext[7:0] };

endmodule