module JC_counter(
   input              clk,
   input              rst_n,
   output reg [63:0]  Q
);

  // On reset clear to 0; otherwise shift right and
  // feed back ~Q[0] into the MSB.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      Q <= 64'b0;
    end else begin
      Q <= {~Q[0], Q[63:1]};
    end
  end

endmodule