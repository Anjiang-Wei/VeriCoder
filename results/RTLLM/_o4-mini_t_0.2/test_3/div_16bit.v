module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output wire [15:0] result,
    output wire [15:0] odd
);

  // registers to hold inputs
  reg [15:0] a_reg;
  reg [7:0]  b_reg;

  // division results
  reg [15:0] result_reg;
  reg [15:0] odd_reg;

  // internal remainder (only 8 bits actually used)
  reg [7:0]  rem;

  integer i;

  // -------------------------------------------------------------------
  // 1) a_reg/b_reg capture -- purely combinational
  // -------------------------------------------------------------------
  always @(*) begin
    a_reg = A;
    b_reg = B;
  end

  // -------------------------------------------------------------------
  // 2) bit‑by‑bit restoring division, 16 iterations
  //    - shift rem←{rem,a_reg[i]}
  //    - if rem>=b_reg then rem-=b_reg and quotient bit=1
  //    - else quotient bit=0
  // -------------------------------------------------------------------
  always @(*) begin
    rem         = 8'd0;
    result_reg  = 16'd0;

    for (i = 15; i >= 0; i = i - 1) begin
      // shift in next dividend bit
      rem = { rem[6:0], a_reg[i] };

      // compare/subtract
      if (rem >= b_reg) begin
        rem              = rem - b_reg;
        result_reg[i]    = 1'b1;
      end
      else begin
        result_reg[i]    = 1'b0;
      end
    end

    // final remainder zero‑extended to 16 bits
    odd_reg = { 8'd0, rem };
  end

  // outputs
  assign result = result_reg;
  assign odd    = odd_reg;

endmodule