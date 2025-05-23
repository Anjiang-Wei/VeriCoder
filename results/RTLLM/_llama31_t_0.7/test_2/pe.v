module pe (
  // Input ports
  input clk,             // Clock signal used for synchronous operations
  input rst,             // Reset signal. Defined as 1 for reset and 0 for reset signal inactive
  input [31:0] a,        // 32-bit input operand A
  input [31:0] b,        // 32-bit input operand B

  // Output ports
  output [31:0] c        // 32-bit output representing the accumulated result
);

// Accumulator Register
reg [31:0] c_reg;

initial begin
    c_reg = 'h00000000;  // Initialize accumulator register to 0 at simulation time
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 'h00000000;  // Reset the accumulator register to 0 when reset signal is high
    end else begin
        c_reg <= c_reg + a * b;  // Accumulate product of input operands in each clock cycle
    end
end

assign c = c_reg;

endmodule