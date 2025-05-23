module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

  // Initialize registers for dividend and divisor
  localparam DIV_WIDTH = 16;
  localparam DIVISOR_WIDTH = 8;
  reg [DIV_WIDTH-1:0] a_reg = A;
  reg [DIVISOR_WIDTH-1:0] b_reg = B;

  // Always block for updating registers
  always @(*) begin
    if (A != a_reg) or (B != b_reg) begin
      a_reg <= A;
      b_reg <= B;
    end
  end

  // Division operation
  always @(posedge clk) begin
    if (a_reg[DIV_WIDTH-1]) begin
      result <= a_reg[DIV_WIDTH-DIVISOR_WIDTH+1:0];
      odd <= a_reg[DIV_WIDTH-1];
    end else begin
      result <= 0;
      odd <= 0;
    end
  end

endmodule