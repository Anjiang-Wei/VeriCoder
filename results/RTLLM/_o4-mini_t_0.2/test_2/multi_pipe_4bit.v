module multi_pipe_4bit #(
  parameter size = 4
)(
  input                    clk,
  input                    rst_n,     // active‑low
  input  [size-1:0]        mul_a,
  input  [size-1:0]        mul_b,
  output reg [2*size-1:0]  mul_out
);

  // local width
  localparam N = 2 * size;

  // Extend multiplicand to N bits by prepending size zeros
  wire [N-1:0] A_ext = { {size{1'b0}}, mul_a };

  // Partial products
  // pp[i] = (mul_b[i] ? A_ext << i : 0)
  wire [N-1:0] pp [0:size-1];
  genvar i;
  generate
    for (i = 0; i < size; i = i + 1) begin
      assign pp[i] = mul_b[i] ? (A_ext << i) : {N{1'b0}};
    end
  endgenerate

  // ------------------------------------------------------------------
  // PIPELINE STAGE 1
  //   sum0_reg <= pp[0] + pp[1]
  //   sum1_reg <= pp[2] + pp[3]
  // ------------------------------------------------------------------
  reg [N-1:0] sum0_reg, sum1_reg;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sum0_reg <= {N{1'b0}};
      sum1_reg <= {N{1'b0}};
    end else begin
      sum0_reg <= pp[0] + pp[1];
      sum1_reg <= pp[2] + pp[3];
    end
  end

  // ------------------------------------------------------------------
  // PIPELINE STAGE 2 (final product)
  //   mul_out <= sum0_reg + sum1_reg
  // ------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      mul_out <= {N{1'b0}};
    else
      mul_out <= sum0_reg + sum1_reg;
  end

endmodule