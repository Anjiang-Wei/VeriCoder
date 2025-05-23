module pe(
    input clk,  // Clock signal used for synchronous operations.
    input rst,  // Reset signal. Defined as 1 for reset and 0 for reset signal inactive.

    input [31:0] a,  // 32-bit input operand A.
    input [31:0] b,  // 32-bit input operand B.

    output [31:0] c  // 32-bit output representing the accumulated result.
);

reg [31:0] c;  // Accumulator register to store the partial sum (intermediate accumulation result).

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0;  // Reset the accumulator register to 0 when reset signal is high.
    end else begin
        c <= c + a * b;  // Update the accumulator register by adding the product of input operands A and B.
    end
end

endmodule