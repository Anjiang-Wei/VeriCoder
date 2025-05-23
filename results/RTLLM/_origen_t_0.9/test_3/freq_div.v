module fir_sparse (
  input clk,
  input rst,
  input [299:0] coeffs,
  input [4:0] stages,
  input [N-1:0] shift_reg,
  input [15:0] in,
  output reg [15:0] out
);