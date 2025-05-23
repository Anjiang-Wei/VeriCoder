module pe(
    input         clk,
    input         rst,
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] c
);

  // Accumulator register declaration
  reg [31:0] acc;

  // Output assignment
  assign c = acc;

  // Always block with asynchronous reset.
  always @(posedge clk or posedge rst) begin
      if (rst) begin
          acc <= 32'd0;
      end else begin
          acc <= acc + (a * b);
      end
  end

endmodule