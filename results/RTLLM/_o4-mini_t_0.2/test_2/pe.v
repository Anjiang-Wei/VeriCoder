module pe(
    input        clk,
    input        rst,
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] c
);

  // accumulator register
  reg [31:0] c_reg;

  // parallel multiplier (lower 32‐bits)
  wire [31:0] product;
  assign product = a * b;

  // on reset or clock edge, update accumulator
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      c_reg <= 32'd0;
    end else begin
      c_reg <= c_reg + product;
    end
  end

  // output assignment
  assign c = c_reg;

endmodule